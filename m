Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaHXO1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:27:45 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39008 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaHXO1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:27:43 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v5 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
In-Reply-To: <1408622959-4096-3-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1408622959-4096-1-git-send-email-r.baldyga@samsung.com> <1408622959-4096-3-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140824:andrzej.p@samsung.com::gBo2Qaj2ltyo1s5V:00000000000000000000000000000000000000001Ln4
X-Hashcash: 1:20:140824:balbi@ti.com::yZyLGIHUcldEt4D2:000001yNn
X-Hashcash: 1:20:140824:gregkh@linuxfoundation.org::5EdIHhtv9CY2rsni:000000000000000000000000000000000002KV5
X-Hashcash: 1:20:140824:m.szyprowski@samsung.com::VaqaaOLSCN8joKM1:00000000000000000000000000000000000002tjW
X-Hashcash: 1:20:140824:k.opasiak@samsung.com::ipWRvKOf0rFXhDWS:00000000000000000000000000000000000000003hyb
X-Hashcash: 1:20:140824:r.baldyga@samsung.com::24WRzkaLtQmSga7Q:00000000000000000000000000000000000000005IZr
X-Hashcash: 1:20:140824:linux-usb@vger.kernel.org::HVouDInP/a5NeTST:0000000000000000000000000000000000006fsk
X-Hashcash: 1:20:140824:r.baldyga@samsung.com::i+5Dpr5h7D5H0Dsq:00000000000000000000000000000000000000006aXF
X-Hashcash: 1:20:140824:linux-kernel@vger.kernel.org::JI5ePyAfPMO7vwI4:000000000000000000000000000000000AaKg
Date: Sun, 24 Aug 2014 16:27:38 +0200
Message-ID: <xa1tppfqufmt.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
> returns endpoint descriptor to userspace. It works only if function
> is active.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

With the change described below:

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/usb/gadget/function/f_fs.c  | 21 +++++++++++++++++++++
>  include/uapi/linux/usb/functionfs.h |  6 ++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 8096f22..ac7b16d 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1032,6 +1032,27 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
>  		case FUNCTIONFS_ENDPOINT_REVMAP:
>  			ret = epfile->ep->num;
>  			break;
> +		case FUNCTIONFS_ENDPOINT_DESC:
> +		{
> +			int desc_idx;
> +			struct usb_endpoint_descriptor *desc;
> +
> +			switch (epfile->ffs->gadget->speed) {
> +			case USB_SPEED_SUPER:
> +				desc_idx = 2;
> +				break;
> +			case USB_SPEED_HIGH:
> +				desc_idx = 1;
> +				break;
> +			default:
> +				desc_idx = 0;
> +			}
> +			desc = epfile->ep->descs[desc_idx];
> +			ret = copy_to_user((void *)value, desc, sizeof(*desc));

This is called under a spin lock, so nope…  The simplest will be to just
unlock prior to copying and then return instead of breaking from the switch:

+			struct usb_endpoint_descriptor desc;
…
+			desc = *epfile->ep->descs[desc_idx];
+			spin_unlock_irq(&epfile->ffs->eps_lock);
+			ret = copy_to_user((void *)value, &desc, sizeof(desc));
+			return ret ? -EFAULT : 0;

> +			if (ret)
> +				ret = -EFAULT;
> +			break;
> +		}
>  		default:
>  			ret = -ENOTTY;
>  		}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
