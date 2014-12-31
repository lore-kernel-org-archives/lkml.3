Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaLaTXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:23:08 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49352 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaLaTXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:23:05 -0500
Date: Wed, 31 Dec 2014 11:23:01 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: gregkh@linuxfoundation.org, anarey@gmail.com, mcgrof@do-not-panic.com,
        tapaswenipathak@gmail.com, joe@perches.com, rmfrfs@gmail.com,
        yejiayily@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: rtl8192u: fix comments
Message-ID: <20141231192301.GA3287@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>, gregkh@linuxfoundation.org,
	anarey@gmail.com, mcgrof@do-not-panic.com,
	tapaswenipathak@gmail.com, joe@perches.com, rmfrfs@gmail.com,
	yejiayily@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1420051376-31180-1-git-send-email-lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420051376-31180-1-git-send-email-lstoakes@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lorenzo,

On Wed, Dec 31, 2014 at 06:42:53PM +0000, Lorenzo Stoakes wrote:
> This patch fixes errors raised by checkpatch.pl relating to use of C99 comments
> in r8192U_dm.c.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8192U_dm.c | 841 ++++++++++++++++++-----------------
>  1 file changed, 432 insertions(+), 409 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
> index 936565d..44f4c38 100644
> --- a/drivers/staging/rtl8192u/r8192U_dm.c
> +++ b/drivers/staging/rtl8192u/r8192U_dm.c
> @@ -21,14 +21,15 @@ Major Change History:
>  #include "r8190_rtl8256.h"
>  #include "r819xU_cmdpkt.h"
>  /*---------------------------Define Local Constant---------------------------*/
> -//
> -// Indicate different AP vendor for IOT issue.
> -//
> -static u32 edca_setting_DL[HT_IOT_PEER_MAX] =
> -		{ 0x5e4322,	0x5e4322,	0x5e4322,	0x604322,	0xa44f,		0x5ea44f};
> -static u32 edca_setting_UL[HT_IOT_PEER_MAX] =
> -		{ 0x5e4322,	0xa44f,		0x5e4322,	0x604322,	0x5ea44f,	0x5ea44f};
> -
> +/*
> + * Indicate different AP vendor for IOT issue.
> + */
This is OK.

> +static u32 edca_setting_DL[HT_IOT_PEER_MAX] = {
> +	0x5e4322, 0x5e4322, 0x5e4322, 0x604322,	0xa44f, 0x5ea44f
> +};
> +static u32 edca_setting_UL[HT_IOT_PEER_MAX] = {
> +	0x5e4322, 0xa44f, 0x5e4322, 0x604322, 0x5ea44f, 0x5ea44f
> +};
But this change is not related to C99 comments and you didn't
explain why this change was made in your log message.
It should probably be in a separate patch.

[...]

-- 
- Jeremiah Mahler
