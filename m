Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbaGYOPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:15:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:51116 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760093AbaGYOPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:15:05 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v2 3/3] usb: gadget: f_fs: make numbers in ep file names the same as ep addresses
In-Reply-To: <1406295363-26998-4-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com> <1406295363-26998-4-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140725:balbi@ti.com::Z423XUKO3fwi1ObB:000001MEn
X-Hashcash: 1:20:140725:andrzej.p@samsung.com::xkhJn8cobqp7HcNT:00000000000000000000000000000000000000001O6D
X-Hashcash: 1:20:140725:m.szyprowski@samsung.com::gwdmQWseAFeqEVYV:00000000000000000000000000000000000001N0T
X-Hashcash: 1:20:140725:linux-usb@vger.kernel.org::t2lbxoVI/J55hy3l:0000000000000000000000000000000000003Ds9
X-Hashcash: 1:20:140725:linux-kernel@vger.kernel.org::qsXJPj8/LxuAUnhT:0000000000000000000000000000000003ox3
X-Hashcash: 1:20:140725:r.baldyga@samsung.com::iocJ1Cs/kT5rpa48:00000000000000000000000000000000000000009D5r
X-Hashcash: 1:20:140725:r.baldyga@samsung.com::tql2iG15gmFZ1v+i:0000000000000000000000000000000000000000AKAz
X-Hashcash: 1:20:140725:gregkh@linuxfoundation.org::gFoBPsjn6lmjN9SG:00000000000000000000000000000000000HIVP
Date: Fri, 25 Jul 2014 16:14:58 +0200
Message-ID: <xa1tzjfxtti5.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25 2014, Robert Baldyga wrote:
> This patch adds FUNCTIONFS_ADDR_NAMES flag to user flags set in
> descriptors, which makes numbers in endpoint file names the same as
> value of bEndpointAddress in endpoint descriptor. It simplifies endpoint
> handling, because now it can be refered using one unique number.
>
> Numbers are in hexadecimal format to have each name of the same lenght,
> and to simplify debugging. The first digit can be 0 or 8 which means
> OUT or IN endpoint direction, and the second digit is simply hexadecimal
> value of endpoint number (which is between 1 and 15).
>
> It needed to store user flags to the moment of endpoint files creation,
> and for this reason there is new field in struct ffs_data named user_flags.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

I don't like this to be honest.  IMO it adds code for little benefit.

> ---
>  drivers/usb/gadget/f_fs.c           | 11 ++++++++---
>  drivers/usb/gadget/u_fs.h           |  2 ++
>  include/uapi/linux/usb/functionfs.h |  1 +
>  3 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index a2e18cc..0b8040b 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -1550,8 +1550,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
>  		epfile->ffs = ffs;
>  		mutex_init(&epfile->mutex);
>  		init_waitqueue_head(&epfile->wait);
> -		sprintf(epfiles->name, "ep%u",
> -			ffs->eps_addrmap[i] & USB_ENDPOINT_NUMBER_MASK);
> +		if (ffs->user_flags & FUNCTIONFS_ADDR_NAMES)
> +			sprintf(epfiles->name, "ep%02x", ffs->eps_addrmap[i]);
> +		else
> +			sprintf(epfiles->name, "ep%u",
> +				ffs->eps_addrmap[i] & USB_ENDPOINT_NUMBER_MASK);
>  		if (!unlikely(ffs_sb_create_file(ffs->sb, epfiles->name, epfile,
>  						 &ffs_epfile_operations,
>  						 &epfile->dentry))) {
> @@ -1912,9 +1915,11 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
>  		break;
>  	case FUNCTIONFS_DESCRIPTORS_MAGIC_V2:
>  		flags = get_unaligned_le32(data + 8);
> +		ffs->user_flags = flags;
>  		if (flags & ~(FUNCTIONFS_HAS_FS_DESC |
>  			      FUNCTIONFS_HAS_HS_DESC |
> -			      FUNCTIONFS_HAS_SS_DESC)) {
> +			      FUNCTIONFS_HAS_SS_DESC |
> +			      FUNCTIONFS_ADDR_NAMES)) {
>  			ret = -ENOSYS;
>  			goto error;
>  		}
> diff --git a/drivers/usb/gadget/u_fs.h b/drivers/usb/gadget/u_fs.h
> index fe31eba..adc6568 100644
> --- a/drivers/usb/gadget/u_fs.h
> +++ b/drivers/usb/gadget/u_fs.h
> @@ -217,6 +217,8 @@ struct ffs_data {
>  	unsigned			hs_descs_count;
>  	unsigned			ss_descs_count;
>  
> +	unsigned			user_flags;
> +
>  	u8				eps_addrmap[15];
>  
>  	unsigned short			strings_count;
> diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
> index 1ab6f06..a29d910 100644
> --- a/include/uapi/linux/usb/functionfs.h
> +++ b/include/uapi/linux/usb/functionfs.h
> @@ -18,6 +18,7 @@ enum functionfs_flags {
>  	FUNCTIONFS_HAS_FS_DESC = 1,
>  	FUNCTIONFS_HAS_HS_DESC = 2,
>  	FUNCTIONFS_HAS_SS_DESC = 4,
> +	FUNCTIONFS_ADDR_NAMES = 8,
>  };
>  
>  #ifndef __KERNEL__
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
