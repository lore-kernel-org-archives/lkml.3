Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaFWTbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:31:15 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56500 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaFWTay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:30:54 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.16-rc2
In-Reply-To: <1403275477-18107-1-git-send-email-balbi@ti.com>
Organization: http://mina86.com/
References: <1403275477-18107-1-git-send-email-balbi@ti.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140623:gregkh@linuxfoundation.org::P8OTfPQX4apGcF4u:000000000000000000000000000000000000JUU
X-Hashcash: 1:20:140623:balbi@ti.com::lTCp8Agw9pjJ0hfn:0000020YL
X-Hashcash: 1:20:140623:linux-usb@vger.kernel.org::sPVommllpls3vcg9:0000000000000000000000000000000000002Law
X-Hashcash: 1:20:140623:balbi@ti.com::ceD3pblZAQaWkkAZ:000002qO4
X-Hashcash: 1:20:140623:linux-kernel@vger.kernel.org::rwoyYPiUauWawha1:0000000000000000000000000000000005/qd
Date: Mon, 23 Jun 2014 21:30:49 +0200
Message-ID: <xa1tha3bv2xi.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20 2014, Felipe Balbi <balbi@ti.com> wrote:
> Here's my first set of fixes for this -rc cycle. Please consider merging
> to your usb-linus branch.

So…  About that…

> Michal Nazarewicz (2):

I'm not sure if you want to include them later on, but those two, which
I think should be in 3.16, are missing from your pull request:

- https://lkml.org/lkml/2014/6/6/129
- https://lkml.org/lkml/2014/6/13/290

>       tools: ffs-test: convert to new descriptor format fixing compilation error

And this one has a newer version (<https://lkml.org/lkml/2014/6/13/287>)
which can wait till 3.17 (since <https://lkml.org/lkml/2014/6/13/290>
fixes the compilation error).

>       usb: gadget: f_fs: fix NULL pointer dereference when there are no strings

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
