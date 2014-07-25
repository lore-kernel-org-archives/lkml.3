Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbaGYOQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:16:00 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:56381 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760557AbaGYOP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:15:58 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v2 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
In-Reply-To: <1406295363-26998-3-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com> <1406295363-26998-3-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140725:m.szyprowski@samsung.com::9YtEa64QF/Qvokdj:00000000000000000000000000000000000000h0n
X-Hashcash: 1:20:140725:linux-usb@vger.kernel.org::YmZykJkMD2P8rmfO:0000000000000000000000000000000000001QZ9
X-Hashcash: 1:20:140725:gregkh@linuxfoundation.org::HjbvuqPO+5F2Zkqa:000000000000000000000000000000000001p1F
X-Hashcash: 1:20:140725:balbi@ti.com::uhLNlPYcnHrP+ZN6:000002MrU
X-Hashcash: 1:20:140725:andrzej.p@samsung.com::8HhfXjNBfnjpN1WI:00000000000000000000000000000000000000002V5t
X-Hashcash: 1:20:140725:linux-kernel@vger.kernel.org::8NgstOMS0yijmtaq:0000000000000000000000000000000002XVx
X-Hashcash: 1:20:140725:r.baldyga@samsung.com::F5DTEj6TFgq+CJMq:00000000000000000000000000000000000000004OQr
X-Hashcash: 1:20:140725:r.baldyga@samsung.com::GxW4Y58nz6oQ3aRB:00000000000000000000000000000000000000008wWx
Date: Fri, 25 Jul 2014 16:15:49 +0200
Message-ID: <xa1twqb1ttgq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25 2014, Robert Baldyga wrote:
> This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
> returns endpoint descriptor to userspace. It works only if function
> is active.

I would argue that user space should never need to know the real
descriptor.  Is this ioctl needed for anything in particular?

>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/gadget/f_fs.c           | 17 +++++++++++++++++
>  include/uapi/linux/usb/functionfs.h |  6 ++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 490b30f..a2e18cc 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -1031,6 +1031,23 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
>  		case FUNCTIONFS_ENDPOINT_REVMAP:
>  			ret = epfile->ep->num;
>  			break;
> +		case FUNCTIONFS_ENDPOINT_DESC:
> +		{
> +			int desc_idx;
> +			struct usb_endpoint_descriptor *desc;
> +
> +			if (epfile->ffs->gadget->speed == USB_SPEED_SUPER)
> +				desc_idx = 2;
> +			else if (epfile->ffs->gadget->speed == USB_SPEED_HIGH)
> +				desc_idx = 1;
> +			else
> +				desc_idx = 0;
> +			desc = epfile->ep->descs[desc_idx];
> +			ret = copy_to_user((void *)value, desc, sizeof(*desc));
> +			if (ret)
> +				ret = -EFAULT;
> +			break;
> +		}
>  		default:
>  			ret = -ENOTTY;
>  		}
> diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
> index 1dc473a..1ab6f06 100644
> --- a/include/uapi/linux/usb/functionfs.h
> +++ b/include/uapi/linux/usb/functionfs.h
> @@ -197,6 +197,12 @@ struct usb_functionfs_event {
>   */
>  #define	FUNCTIONFS_ENDPOINT_REVMAP	_IO('g', 129)
>  
> +/*
> + * Returns endpoint descriptor. In funciton is not active returns -ENODEV.
> + */
> +#define	FUNCTIONFS_ENDPOINT_DESC	_IOR('g', 130, \
> +					     struct usb_endpoint_descriptor)
> +
>  
>  
>  #endif /* _UAPI__LINUX_FUNCTIONFS_H__ */
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
