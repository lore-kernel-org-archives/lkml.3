Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaHXOb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:31:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52719 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaHXObY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:31:24 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v5 3/3] usb: gadget: f_fs: virtual endpoint address mapping
In-Reply-To: <1408622959-4096-4-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1408622959-4096-1-git-send-email-r.baldyga@samsung.com> <1408622959-4096-4-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140824:gregkh@linuxfoundation.org::yhG7yRzz3fXBujzQ:000000000000000000000000000000000000bEn
X-Hashcash: 1:20:140824:r.baldyga@samsung.com::8Nb/vFHZTYs/oxu6:00000000000000000000000000000000000000000lhQ
X-Hashcash: 1:20:140824:andrzej.p@samsung.com::UuBeYhfeIw3rAFb3:00000000000000000000000000000000000000000i9K
X-Hashcash: 1:20:140824:linux-usb@vger.kernel.org::UMHZsTUePNRtGlda:0000000000000000000000000000000000001PMh
X-Hashcash: 1:20:140824:r.baldyga@samsung.com::Mpt8ga0P249g/ywM:0000000000000000000000000000000000000000366H
X-Hashcash: 1:20:140824:m.szyprowski@samsung.com::xtQs0PSau/r6REb4:00000000000000000000000000000000000003x8s
X-Hashcash: 1:20:140824:k.opasiak@samsung.com::6O6wmaVpPqbC8+aT:00000000000000000000000000000000000000006fNq
X-Hashcash: 1:20:140824:balbi@ti.com::VPb5zUycFRU6GMHo:000008+Ge
X-Hashcash: 1:20:140824:linux-kernel@vger.kernel.org::spgNbA6rKOSJKl7z:000000000000000000000000000000000BSFd
Date: Sun, 24 Aug 2014 16:31:20 +0200
Message-ID: <xa1tmwauufgn.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> This patch introduces virtual endpoint address mapping. It separates
> function logic form physical endpoint addresses making it more hardware
> independent.
>
> Following modifications changes user space API, so to enable them user
> have to switch on the FUNCTIONFS_VIRTUAL_ADDR flag in descriptors.
>
> Endpoints are now refered using virtual endpoint addresses chosen by
> user in endpoint descpriptors. This applies to each context when endpoint
> address can be used:
> - when accessing endpoint files in FunctionFS filesystemi (in file name),
> - in setup requests directed to specific endpoint (in wIndex field),
> - in descriptors returned by FUNCTIONFS_ENDPOINT_DESC ioctl.
>
> In endpoint file names the endpoint address number is formatted as
> double-digit hexadecimal value ("ep%02x") which has few advantages -
> it is easy to parse, allows to easly recognize endpoint direction basing
> on its name (IN endpoint number starts with digit 8, and OUT with 0)
> which can be useful for debugging purpose, and it makes easier to introduce
> further features allowing to use each endpoint number in both directions
> to have more endpoints available for function if hardware supports this
> (for example we could have ep01 which is endpoint 1 with OUT direction,
> and ep81 which is endpoint 1 with IN direction).
>
> Physical endpoint address can be still obtained using ioctl named
> FUNCTIONFS_ENDPOINT_REVMAP, but now it's not neccesary to handle
> USB transactions properly.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
