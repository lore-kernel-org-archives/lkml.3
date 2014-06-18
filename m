Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966293AbaFRLpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:45:04 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59110 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954AbaFRLpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:45:01 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: "Yang\,Wei" <Wei.Yang@windriver.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <53A0E6A8.6070803@windriver.com>
Organization: http://mina86.com/
References: <Pine.LNX.4.44L0.1406171017090.1187-100000@iolanthe.rowland.org> <53A0E6A8.6070803@windriver.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140618:wei.yang@windriver.com::me8qNPtrkeEnAhU6:00000000000000000000000000000000000000010dQ
X-Hashcash: 1:20:140618:balbi@ti.com::fWvvbtR7tRn2PZQH:000005cYu
X-Hashcash: 1:20:140618:linux-usb@vger.kernel.org::X9/wm+QaQXSplBqS:0000000000000000000000000000000000004ejv
X-Hashcash: 1:20:140618:stern@rowland.harvard.edu::Wh1flVghurIY8aE9:0000000000000000000000000000000000008ARO
X-Hashcash: 1:20:140618:linux-kernel@vger.kernel.org::Mli0Bm8zL5rMoXsk:000000000000000000000000000000000Gk83
Date: Wed, 18 Jun 2014 13:44:56 +0200
Message-ID: <xa1t7g4ev3uv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18 2014, Yang,Wei wrote:
> On 06/17/2014 10:18 PM, Alan Stern wrote:
>> That is a strange question to ask.  If you did not know that I approved
>> the patch, why did you insert my Acked-By:?

> I added your Acked-By, as when you reviewed V3, you mentioned that I 
> *may* add your Acked-by in this patch. If I misunderstood your point, I 
> am so sorry for that.

Alan's point is that if you have any doubts whether someone approves
your patch you should *not* add their Acked-by.  So adding someone's
Acked-by and then asking if they are fine with the patch is
contradictory -- the former indicates that you believe the person is
fine with the patch, while the latter shows that you aren't.

Alan wrote:

>>> With that change, you may add
>>>
>>> Acked-by: Alan Stern <stern@rowland.harvard.edu>

so after adding “that change” you are in your right to add Alan's
Acked-by, but what that also means is that Alan will be fine with the
patch if you make the requested change, so you don't need to ask for an
opinion again.

PS. Note that “having any doubts” also means that if someone gave you
    their Acked-by, but then you substantially rewrite the patch, you
    probably should consider removing their Acked-by.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
