Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbbAQXhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:37:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbAQXht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:37:49 -0500
Date: Sat, 17 Jan 2015 15:09:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arno Tiemersma <arno.tiemersma@gmail.com>
Cc: jason@lakedaemon.net, jake@lwn.net, antonysaraev@gmail.com,
        eric.rost@mybabylon.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: Fix checkpatch warnings
Message-ID: <20150117230922.GA20761@kroah.com>
References: <1420902047-7569-1-git-send-email-arno.tiemersma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420902047-7569-1-git-send-email-arno.tiemersma@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 04:00:47PM +0100, Arno Tiemersma wrote:
> Remove do {} while (0) loops around single statements in
> skein/skein_block.c
> 
> Signed-off-by: Arno Tiemersma <arno.tiemersma@gmail.com>
> ---
>  drivers/staging/skein/skein_block.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
> index 66261ab..39dccf8 100644
> --- a/drivers/staging/skein/skein_block.c
> +++ b/drivers/staging/skein/skein_block.c
> @@ -83,9 +83,7 @@ do {                                                                      \
>  #else
>  /* looping version */
>  #define R256(p0, p1, p2, p3, ROT, r_num) \
> -do { \
> -	ROUND256(p0, p1, p2, p3, ROT, r_num); \
> -} while (0)
> +	ROUND256(p0, p1, p2, p3, ROT, r_num)
>  
>  #define I256(R) \
>  do { \
> @@ -174,9 +172,7 @@ do {                                                                      \
>  
>  #else /* looping version */
>  #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)                 \
> -do {                                                                     \
> -	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num);            \
> -} while (0)
> +	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)
>  
>  #define I512(R)                                                           \
>  do {                                                                      \
> @@ -263,10 +259,8 @@ do {                                                                          \
>  #if SKEIN_UNROLL_1024 == 0
>  #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
>  	      ROT, rn)                                                        \
> -do {                                                                          \
>  	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
> -		  pF, ROT, rn);                                               \
> -} while (0)
> +		  pF, ROT, rn)
>  
>  #define I1024(R)                                                          \
>  do {                                                                      \
> @@ -291,10 +285,8 @@ do {                                                                      \
>  #else /* looping version */
>  #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
>  	      ROT, rn)                                                        \
> -do {                                                                          \
>  	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
> -		  pF, ROT, rn);                                               \
> -} while (0)
> +		  pF, ROT, rn)
>  
>  #define I1024(R)                                                           \
>  do {                                                                       \
> -- 
> 2.1.0
> 

Doesn't apply to my tree :(
