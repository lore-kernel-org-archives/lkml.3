Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaLXOcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 09:32:39 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45203 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaLXOch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 09:32:37 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        k.opasiak@samsung.com, stern@rowland.harvard.edu,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v5] usb: gadget: f_fs: add "no_disconnect" mode
In-Reply-To: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.3 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141224:r.baldyga@samsung.com::w5oPn1ME6AWPMSLd:00000000000000000000000000000000000000000f+j
X-Hashcash: 1:20:141224:linux-usb@vger.kernel.org::NBIFAxLAy+AP2uno:0000000000000000000000000000000000000apb
X-Hashcash: 1:20:141224:linux-kernel@vger.kernel.org::ZmwtCbZTN9TInZ2f:0000000000000000000000000000000001Tq8
X-Hashcash: 1:20:141224:m.szyprowski@samsung.com::Hwo6Vv3vclShX1rb:00000000000000000000000000000000000001Z3B
X-Hashcash: 1:20:141224:gregkh@linuxfoundation.org::sg3+9ZtMHcxBdy9Q:000000000000000000000000000000000001MrD
X-Hashcash: 1:20:141224:stern@rowland.harvard.edu::/IHjSUZufI4Fx5Mi:0000000000000000000000000000000000002EqM
X-Hashcash: 1:20:141224:k.opasiak@samsung.com::0pR9c1lXYditCEcg:00000000000000000000000000000000000000003WSQ
X-Hashcash: 1:20:141224:balbi@ti.com::R0pSWTN8JxcG0Uas:00000Aknh
X-Hashcash: 1:20:141224:r.baldyga@samsung.com::q6FNPquuLpAL+7Y1:0000000000000000000000000000000000000000FNlX
Date: Wed, 24 Dec 2014 15:32:32 +0100
Message-ID: <xa1tzjadp18f.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18 2014, Robert Baldyga wrote:
> Since we can compose gadgets from many functions, there is the problem
> related to gadget breakage while FunctionFS daemon being closed. FFS
> function is userspace code so there is no way to know when it will close
> files (it doesn't matter what is the reason of this situation, it can
> be daemon logic, program breakage, process kill or any other). So when
> we have another function in gadget which, for example, sends some amount
> of data, does some software update or implements some real-time functionality,
> we may want to keep the gadget connected despite FFS function is no longer
> functional.
>
> We can't just remove one of functions from gadget since it has been
> enumerated, so the only way to keep entire gadget working is to make
> broken FFS function deactivated but still visible to host. For this
> purpose this patch introduces "no_disconnect" mode. It can be enabled
> by setting mount option "no_disconnect=1", and results with defering
> function disconnect to the moment of reopen ep0 file or filesystem
> unmount. After closing all endpoint files, FunctionFS is set to state
> FFS_DEACTIVATED.
>
> When ffs->state == FFS_DEACTIVATED:
> - function is still bound and visible to host,
> - setup requests are automatically stalled,
> - transfers on other endpoints are refused,
> - epfiles, except ep0, are deleted from the filesystem,
> - opening ep0 causes the function to be closed, and then FunctionFS
>   is ready for descriptors and string write,
> - altsetting change causes the function to be closed - we want to keep
>   function alive until another functions are potentialy used, altsetting
>   change means that another configuration is being selected or USB cable
>   was unplugged, which indicates that we don't need to stay longer in
>   FFS_DEACTIVATED state
> - unmounting of the FunctionFS instance causes the function to be closed.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> @@ -1417,7 +1429,11 @@ static void ffs_data_opened(struct ffs_data *ffs)
>  	ENTER();
>  
>  	atomic_inc(&ffs->ref);
> -	atomic_inc(&ffs->opened);
> +	if (atomic_add_return(1, &ffs->opened) == 1)
> +		if (ffs->state == FFS_DEACTIVATED) {
> +			ffs->state = FFS_CLOSING;
> +			ffs_data_reset(ffs);
> +	}

Wrong indention.  Why not:

+	if (atomic_add_return(1, &ffs->opened) == 1 &&
+	    ffs->state == FFS_DEACTIVATED) {
+		ffs->state = FFS_CLOSING;
+		ffs_data_reset(ffs);
+	}

>  }
>  
>  static void ffs_data_put(struct ffs_data *ffs)
> @@ -1439,6 +1455,21 @@ static void ffs_data_closed(struct ffs_data *ffs)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
