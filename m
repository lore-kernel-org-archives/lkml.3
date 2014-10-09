Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaJIKjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:39:36 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:57154 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaJIKjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:39:25 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrzej.p@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: remove redundant ffs_data_get()
In-Reply-To: <1412840476-2767-1-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1412840476-2767-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141009:m.szyprowski@samsung.com::7/xn7xk5l79NHP9R:000000000000000000000000000000000000008y2
X-Hashcash: 1:20:141009:r.baldyga@samsung.com::ewF4NH4abu/rSuOp:00000000000000000000000000000000000000000yxS
X-Hashcash: 1:20:141009:linux-usb@vger.kernel.org::BSbX1+tgdR1EvOiU:0000000000000000000000000000000000001DaN
X-Hashcash: 1:20:141009:gregkh@linuxfoundation.org::Bq5JrOhdOdZvvETn:000000000000000000000000000000000001EF3
X-Hashcash: 1:20:141009:balbi@ti.com::rRqj7SDTSTVo7Ndh:000002A0/
X-Hashcash: 1:20:141009:linux-kernel@vger.kernel.org::OWTVruAbzrkiZiNw:0000000000000000000000000000000002hJW
X-Hashcash: 1:20:141009:r.baldyga@samsung.com::qPmsV3j9jYXpqvbg:00000000000000000000000000000000000000002fCG
X-Hashcash: 1:20:141009:andrzej.p@samsung.com::ofbwy1BuxLy9R4yZ:00000000000000000000000000000000000000008lqd
Date: Thu, 09 Oct 2014 12:39:19 +0200
Message-ID: <xa1ttx3dedd4.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> During FunctionFS bind, ffs_data_get() function was called twice
> (in functionfs_bind() and in ffs_do_functionfs_bind()), while on unbind
> ffs_data_put() was called once (in functionfs_unbind() function).
> In result refcount never reached value 0, and ffs memory resources has
> been never released.
>
> Since ffs_data_get() call in ffs_do_functionfs_bind() is redundant
> and not neccessary, we remove it to have equal number of gets ans puts,
> and free allocated memory after refcount reach 0.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/usb/gadget/function/f_fs.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 7c6771d..12dbdaf 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -2663,8 +2663,6 @@ static inline struct f_fs_opts *ffs_do_functionfs_bind(struct usb_function *f,
>  	func->conf = c;
>  	func->gadget = c->cdev->gadget;
>  
> -	ffs_data_get(func->ffs);
> -
>  	/*
>  	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
>  	 * configurations are bound in sequence with list_for_each_entry,
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
