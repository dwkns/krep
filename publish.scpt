FasdUAS 1.101.10   ��   ��    l     ����  I    �� ��
�� .sysoexecTEXT���     TEXT  m        �  � 
 #   A u t o   i n c r i m e n t s   t h e   v e r s i o n   n u m b e r   o f   K r e p   a n d   t h e n   u p l o a d s   i t   t o   g i t . ; 
 #   g e t   t h e   l a s t   g i t   c o m m i t   m e s s a g e ; 
 g i t C o m m i t M e s s a g e = ` g i t   l o g   - 1   - - p r e t t y = % B ` ; 
 
 #   g e t   t h e   d i r e c t o r y   t h a t   t h i s   s c r i p t   i s   r u n n i n g   f r o m . ; 
 D I R = " $ (   c d   " $ (   d i r n a m e   " $ 0 "   ) "   & &   p w d   ) " ; 
 
 #   r e a d   t h e   c u r r e n t   v e r s i o n   n u m b e r   f r o m   t h e   a p p   p l i s t ; 
 C F B u n d l e S h o r t V e r s i o n S t r i n g = ` d e f a u l t s   r e a d   $ D I R / K r e p . a p p / C o n t e n t s / I n f o . p l i s t   C F B u n d l e S h o r t V e r s i o n S t r i n g ` ; 
 C F B u n d l e V e r s i o n = ` d e f a u l t s   r e a d   $ D I R / / K r e p . a p p / C o n t e n t s / I n f o . p l i s t   C F B u n d l e V e r s i o n ` ; 
 
 #   i n c r e a s e   t h e   v e r s i o n   n u m b e r s   b y   0 . 1 ; 
 n e w C F B u n d l e S h o r t V e r s i o n S t r i n g = ` e c h o   $ C F B u n d l e S h o r t V e r s i o n S t r i n g   +   0 . 0 1   |   b c ` ; 
 n e w C F B u n d l e V e r s i o n = ` e c h o   $ C F B u n d l e V e r s i o n   +   0 . 0 1   |   b c ` ; 
 
 #   w r i t e   t h e   n e w   v e r s i o n   n u m b e r s   t o   t h e   p l i s t s ; 
 d e f a u l t s   w r i t e   $ D I R / K r e p . a p p / C o n t e n t s / I n f o . p l i s t   C F B u n d l e S h o r t V e r s i o n S t r i n g   $ n e w C F B u n d l e S h o r t V e r s i o n S t r i n g ; 
 d e f a u l t s   w r i t e   $ D I R / K r e p . a p p / C o n t e n t s / I n f o . p l i s t   C F B u n d l e V e r s i o n   $ n e w C F B u n d l e V e r s i o n ; 
 
 #   d o   t h e   g i t   c o m m i t ; 
 # g i t   a d d   - A ; 
 # g i t   c o m m i t   - m   " $ g i t C o m m i t M e s s a g e   ( p u b l i s h ) " ; 
 # g i t   p u s h   - - a l l ;��  ��  ��       ��  	��    ��
�� .aevtoappnull  �   � **** 	 �� 
����  ��
�� .aevtoappnull  �   � **** 
 k         ����  ��  ��        ��
�� .sysoexecTEXT���     TEXT�� �j  ascr  ��ޭ