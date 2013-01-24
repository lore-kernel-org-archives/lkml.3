Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3AXKLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:11:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab3AXKLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:11:09 -0500
Date: Thu, 24 Jan 2013 11:11:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 5/6] Drivers: hid: hid-hyperv: Use consolidated GUID
 definitions
In-Reply-To: <1358991765-22715-5-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LNX.2.00.1301241110210.31600@pobox.suse.cz>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com> <1358991765-22715-1-git-send-email-kys@microsoft.com> <1358991765-22715-5-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2013, K. Y. Srinivasan wrote:

> Use the consolidated GUID definitions in the Hyper-V mouse driver.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

Greg, I guess you are taking this as a whole?

Thanks.

> ---
>  drivers/hid/hid-hyperv.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> index 3d62781..aa3fec0 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -568,8 +568,7 @@ static int mousevsc_remove(struct hv_device *dev)
>  
>  static const struct hv_vmbus_device_id id_table[] = {
>  	/* Mouse guid */
> -	{ VMBUS_DEVICE(0x9E, 0xB6, 0xA8, 0xCF, 0x4A, 0x5B, 0xc0, 0x4c,
> -		       0xB9, 0x8B, 0x8B, 0xA1, 0xA1, 0xF3, 0xF9, 0x5A) },
> +	{ HV_MOUSE_GUID, },
>  	{ },
>  };
>  
> -- 
> 1.7.4.1
> 

-- 
Jiri Kosina
SUSE Labs
