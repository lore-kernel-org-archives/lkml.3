Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaFLFX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 01:23:58 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:64582 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaFLFX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:23:56 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
Date: Thu, 12 Jun 2014 07:23:51 +0200
From: Olaf Hering <olaf@aepfle.de>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/cirrus: bind also to qemu-xen-traditional
Message-ID: <20140612052351.GA25374@aepfle.de>
References: <1397199383-30186-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397199383-30186-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Fri, Apr 11, Olaf Hering wrote:

> qemu as used by xend/xm toolstack uses a different subvendor id.
> Bind the drm driver also to this emulated card.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> ---
>  drivers/gpu/drm/cirrus/cirrus_drv.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
> index 953fc8a..8555548 100644
> --- a/drivers/gpu/drm/cirrus/cirrus_drv.c
> +++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
> @@ -31,6 +31,8 @@ static struct drm_driver driver;
>  static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
>  	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, 0x1af4, 0x1100, 0,
>  	  0, 0 },
> +	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, PCI_VENDOR_ID_XEN,
> +	  0x0001, 0, 0, 0 },
>  	{0,}
>  };
>  
