Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3LMI76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:59:58 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53994 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3LMI75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:59:57 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 13 Dec 2013 00:59:50 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: message: Mark function
 mpt_SoftResetHandler() as static in mptbase.c
Message-ID: <20131213085950.GH4386@leaf>
References: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:33:11AM +0530, Rashika Kheria wrote:
> This patch marks the function mpt_SoftResetHandler() as static in mptbase.c
> because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in fusion/mptbase.c:
> drivers/message/fusion/mptbase.c:7011:1: warning: no previous prototype for ‘mpt_SoftResetHandler’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/message/fusion/mptbase.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 767ff4d..c783a42 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -7007,7 +7007,7 @@ EXPORT_SYMBOL(mpt_halt_firmware);
>   *	IOC doesn't reply to any outstanding request. This will transfer IOC
>   *	to READY state.
>   **/
> -int
> +static int
>  mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
>  {
>  	int		 rc;
> -- 
> 1.7.9.5
> 
