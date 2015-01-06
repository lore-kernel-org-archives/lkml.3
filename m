Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbbAFGp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:45:26 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61968 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbAFGpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:45:23 -0500
Message-ID: <54AB8480.5060603@gmail.com>
Date: Tue, 06 Jan 2015 07:45:20 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] adjtimex.2: Update modes field of adjtimex
References: <1419426040-16090-1-git-send-email-standby24x7@gmail.com> <1419426040-16090-2-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1419426040-16090-2-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2014 02:00 PM, Masanari Iida wrote:
> This patch update modes field of adjtimex man page.

Hello Masanari Iida,

Thanks for this patch. As it happened, some other
recent changes to the page covered the same changes
already, so this patch is obsolete. You can find the no
current version in Git (see
http://git.kernel.org/cgit/docs/man-pages/man-pages.git/tree/man2/adjtimex.2
)

Cheers,

Michael


> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  man2/adjtimex.2 | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
> index f2a8b8c..b4450e8 100644
> --- a/man2/adjtimex.2
> +++ b/man2/adjtimex.2
> @@ -92,8 +92,15 @@ combination of zero or more of the following bits:
>  #define ADJ_ESTERROR          0x0008 /* estimated time error */
>  #define ADJ_STATUS            0x0010 /* clock status */
>  #define ADJ_TIMECONST         0x0020 /* pll time constant */
> +#define ADJ_TAI               0x0080 /* set TAI offset */
> +#define ADJ_SETOFFSET         0x0100 /* add 'time' to current time */
> +#define ADJ_MICRO             0x1000 /* select microsecond
> +                                        resolution */
> +#define ADJ_NANO              0x2000 /* select nanosecond
> +                                        resolution */
>  #define ADJ_TICK              0x4000 /* tick value */
> -#define ADJ_OFFSET_SINGLESHOT 0x8001 /* old-fashioned adjtime() */
> +#define ADJ_OFFSET_SINGLESHOT 0x8001 /* old-fashioned adjtime */
> +#define ADJ_OFFSET_SS_READ    0xa001 /* read-only adjtime */
>  .fi
>  .in
>  .PP
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
