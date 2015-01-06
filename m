Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbbAFPU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:20:57 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45974 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbAFPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:20:55 -0500
Message-ID: <54ABFD54.9000705@gmail.com>
Date: Tue, 06 Jan 2015 16:20:52 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Laurent Georget <laurent.georget@supelec.fr>,
        linux-man <linux-man@vger.kernel.org>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        Jeff Epler <jepler@unpythonic.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 2/2] adjtimex.2: Change 'PPM' (parts per million) to 'ppm'
References: <54A2DEAD.2050708@supelec.fr> <54A72360.3070807@supelec.fr> <54A724BE.8050409@supelec.fr>
In-Reply-To: <54A724BE.8050409@supelec.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2015 12:07 AM, Laurent Georget wrote:
> Hi again,
> 
> this is the second patch of the new series of patchs for adjtimex.2. 
> 
> This is a trivia patch correcting "PPM" (parts per million) to 
> the more usual "ppm".
> Credits to Jeff Epler <jepler@unpythonic.net>.

Thanks, Laurent (andf Jeff). Patch applied.

Laurent, please watch out: your patches are injecting trailing
white space on lines. My release scripts clean those up, but
it means that patches apply with "noise".

Cheers,

Michael

> 
> ---
>  man2/adjtimex.2 | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
> index ff4b23e..dbb2333 100644
> --- a/man2/adjtimex.2
> +++ b/man2/adjtimex.2
> @@ -54,7 +54,7 @@ struct timex {
>      long offset;      /* Time offset; nanoseconds, if STA_NANO
>                           status flag is set, otherwise
>                           microseconds */
> -    long freq;        /* Frequency offset, in units of 2^-16 PPM
> +    long freq;        /* Frequency offset, in units of 2^-16 ppm
>                           (parts per million) (see NOTES below) */
>      long maxerror;    /* Maximum error (microseconds) */
>      long esterror;    /* Estimated error (microseconds) */
> @@ -62,8 +62,7 @@ struct timex {
>      long constant;    /* PLL (phase-locked loop) time constant */
>      long precision;   /* Clock precision (microseconds,
>                           read-only) */
> -    long tolerance;   /* Clock frequency tolerance (PPM,
> -                         read-only) */
> +    long tolerance;   /* Clock frequency tolerance (ppm, read-only) */
>      struct timeval time;
>                        /* Current time (read-only, except for
>                           ADJ_SETOFFSET); upon return, time.tv_usec
> @@ -71,13 +70,13 @@ struct timex {
>                           flag is set, otherwise microseconds */
>      long tick;        /* Microseconds between clock ticks */
>      long ppsfreq;     /* PPS (pulse per second) frequency
> -                         (2^-16 PPM (see NOTES), read-only) */
> +                         (2^-16 ppm (see NOTES), read-only) */
>      long jitter;      /* PPS jitter (read-only); nanoseconds, if
>                           STA_NANO status flag is set, otherwise
>                           microseconds */
>      int  shift;       /* PPS interval duration
>                           (seconds, read-only) */
> -    long stabil;      /* PPS stability (2^-16 PPM (see NOTES), read-only) */
> +    long stabil;      /* PPS stability (2^-16 ppm (see NOTES), read-only) */
>      long jitcnt;      /* PPS jitter limit exceeded (read-only) */
>      long calcnt;      /* PPS calibration intervals (read-only) */
>      long errcnt;      /* PPS calibration errors (read-only) */
> @@ -349,9 +348,9 @@ In struct
>  .IR ppsfreq ,
>  and 
>  .I stabil
> -are PPM (parts per million) with a 16-bits fractional part, which means that a
> -value of 1 in one of those fields actually means 2^-16 PPM, and 2^16=65535 is 
> -1 PPM. This is the case for both input values (in the case of
> +are ppm (parts per million) with a 16-bits fractional part, which means that a
> +value of 1 in one of those fields actually means 2^-16 ppm, and 2^16=65535 is 
> +1 ppm. This is the case for both input values (in the case of
>  .IR freq )
>  and output values.
>  .SH CONFORMING TO
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
