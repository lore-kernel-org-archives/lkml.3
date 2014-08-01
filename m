Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbaHAWsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:48:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbaHAWsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:48:06 -0400
Date: Fri, 1 Aug 2014 15:48:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] usb: host: ehci-msm: Make of_device_id array const
Message-ID: <20140801224804.GA29608@kroah.com>
References: <1406724285-14641-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406724285-14641-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 06:14:45PM +0530, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as const.
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/usb/host/ehci-msm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
> index 982c09b..934b39d 100644
> --- a/drivers/usb/host/ehci-msm.c
> +++ b/drivers/usb/host/ehci-msm.c
> @@ -190,7 +190,7 @@ static const struct dev_pm_ops ehci_msm_dev_pm_ops = {
>  	.resume          = ehci_msm_pm_resume,
>  };
>  
> -static struct of_device_id msm_ehci_dt_match[] = {
> +static const struct of_device_id msm_ehci_dt_match[] = {
>  	{ .compatible = "qcom,ehci-host", },
>  	{}
>  };
> -- 
> 1.7.9.5

This patch is already in my tree, right?  Why submit it again?

confused,

greg k-h
