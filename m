Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaIBMpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:45:51 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:44526 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaIBMpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:45:49 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>, balbi@ti.com,
        mgautam@codeaurora.org, andrzej.p@samsung.com
Cc: jin.can.zhuang@intel.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@intel.com,
        hang.yuan@intel.com
Subject: Re: [PATCH] usb: gadget: f_fs: add usb_functionfs_descs_head_v2
In-Reply-To: <20140902065836.GA23094@intel.com>
Organization: http://mina86.com/
References: <20140902065836.GA23094@intel.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140902:jin.can.zhuang@intel.com::cTv+H1JysT+qb6dg:00000000000000000000000000000000000000Wxy
X-Hashcash: 1:20:140902:linux-kernel@vger.kernel.org::sK3YlO68ByGTHjqm:0000000000000000000000000000000000ifL
X-Hashcash: 1:20:140902:jin.can.zhuang@intel.com::wpiFiQou7c7ZwACQ:00000000000000000000000000000000000000r5v
X-Hashcash: 1:20:140902:balbi@ti.com::ZOhQCa3Jb7q+eyUo:000001Akg
X-Hashcash: 1:20:140902:hang.yuan@intel.com::eWEODsFOlfWc/4ro:0000000000000000000000000000000000000000001gbg
X-Hashcash: 1:20:140902:linux-api@vger.kernel.org::PSY8kG9uPgQkY22q:0000000000000000000000000000000000003VOv
X-Hashcash: 1:20:140902:mgautam@codeaurora.org::63GnikYYEhg+ZqSB:0000000000000000000000000000000000000005nS0
X-Hashcash: 1:20:140902:david.a.cohen@intel.com::jBOenJHRkpyG57ix:00000000000000000000000000000000000000B4TG
X-Hashcash: 1:20:140902:andrzej.p@samsung.com::l8u6DgN0vGzNO14+:0000000000000000000000000000000000000000EyFm
Date: Tue, 02 Sep 2014 14:45:44 +0200
Message-ID: <xa1twq9mry13.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02 2014, Zhuang Jin Can <jin.can.zhuang@intel.com> wrote:
> Add usb_functionfs_descs_head_v2 structure for the new layout of
> descriptors.

NAK.  It's a duplicate of <https://lkml.org/lkml/2014/6/6/128> and even
more importantly, the format of the header is not fixed past the flags
field (e.g. fs_count may be missing), so fs_count, hs_count and ss_count
cannot be in the structure.

> Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> ---
>  include/uapi/linux/usb/functionfs.h |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
> index 0154b28..0b3f9fc 100644
> --- a/include/uapi/linux/usb/functionfs.h
> +++ b/include/uapi/linux/usb/functionfs.h
> @@ -32,6 +32,15 @@ struct usb_endpoint_descriptor_no_audio {
>  	__u8  bInterval;
>  } __attribute__((packed));
>  
> +struct usb_functionfs_descs_head_v2 {
> +	__le32 magic;
> +	__le32 length;
> +	__le32 flags;
> +	__le32 fs_count;
> +	__le32 hs_count;
> +	__le32 ss_count;
> +} __attribute__((packed));
> +
>  /* Legacy format, deprecated as of 3.14. */
>  struct usb_functionfs_descs_head {
>  	__le32 magic;

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
