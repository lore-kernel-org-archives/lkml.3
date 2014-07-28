Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaG1KY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:24:27 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58213 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaG1KYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:24:25 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH v2 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
In-Reply-To: <53D5E958.40100@samsung.com>
Organization: http://mina86.com/
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com> <1406295363-26998-3-git-send-email-r.baldyga@samsung.com> <xa1twqb1ttgq.fsf@mina86.com> <53D5E958.40100@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140728:gregkh@linuxfoundation.org::T7JnvgpM/gPtri+D:000000000000000000000000000000000000SOy
X-Hashcash: 1:20:140728:m.szyprowski@samsung.com::wc7iLFS2fv8ncImB:00000000000000000000000000000000000001J2X
X-Hashcash: 1:20:140728:linux-kernel@vger.kernel.org::JDRyDksYNxN0Pmve:0000000000000000000000000000000001vrU
X-Hashcash: 1:20:140728:balbi@ti.com::eOV0jdhiw+UPKgIX:000002rCE
X-Hashcash: 1:20:140728:r.baldyga@samsung.com::DBJlbMqPLV2v1Tou:00000000000000000000000000000000000000005fF0
X-Hashcash: 1:20:140728:andrzej.p@samsung.com::lzIn5eOU2KhniQ5I:00000000000000000000000000000000000000006rYi
X-Hashcash: 1:20:140728:linux-usb@vger.kernel.org::lqAjAYUTEWQg8SA7:000000000000000000000000000000000000CAr8
Date: Mon, 28 Jul 2014 12:24:21 +0200
Message-ID: <xa1tha21rdbe.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Fri, Jul 25 2014, Robert Baldyga wrote:
>>> This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
>>> returns endpoint descriptor to userspace. It works only if function
>>> is active.

> On 07/25/2014 04:15 PM, Michal Nazarewicz wrote:
>> I would argue that user space should never need to know the real
>> descriptor.  Is this ioctl needed for anything in particular?

On Mon, Jul 28 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> It's needed, at least, to inform user space about maximum possible
> wMaxPacketSize value for the endpoint, which is returned by autoconfig
> through the endpoint descriptor when value set by user is zero.
>
> Descriptor returned form this ioctl is mostly the same as descriptor
> created by user. I guess you meant that real descriptor is this one,
> which contains real endpoint address, because it's probably only datum
> in real descriptor which should be never known by user space.
>
> This ioctl would be also useful in case, when FunctionFS daemon obtains
> endpoint descriptors from another daemon, and do not have access to
> original descriptor structures given do FunctionFS.

All right, I think I can go with that.

>>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
