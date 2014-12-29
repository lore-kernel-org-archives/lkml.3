Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaL2R0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:26:12 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:37202 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaL2R0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:26:10 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Stefan Strogin <stefan.strogin@gmail.com>,
        "Stefan I. Strogin" <s.strogin@partner.samsung.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Stefan Strogin <stefan.strogin@gmail.com>
Subject: Re: [PATCH 2/3] mm: cma: introduce /proc/cmainfo
In-Reply-To: <54A160B6.5030605@gmail.com>
Organization: http://mina86.com/
References: <cover.1419602920.git.s.strogin@partner.samsung.com> <264ce8ad192124f2afec9a71a2fc28779d453ba7.1419602920.git.s.strogin@partner.samsung.com> <xa1tzjaaz9f9.fsf@mina86.com> <54A160B6.5030605@gmail.com>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.3 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141229:zhuhui@xiaomi.com::SxtI9Zn3u0dcVFJm:00000000000000000000000000000000000000000000020J
X-Hashcash: 1:20:141229:weijie.yang@samsung.com::dXpdmB4MPHMtLosU:000000000000000000000000000000000000000WCS
X-Hashcash: 1:20:141229:aneesh.kumar@linux.vnet.ibm.com::Tac+2sg7MfptPlNp:00000000000000000000000000000012ka
X-Hashcash: 1:20:141229:m.szyprowski@samsung.com::Hv06Hl5IjDjglLWO:00000000000000000000000000000000000000khk
X-Hashcash: 1:20:141229:stefan.strogin@gmail.com::EFGAyxyHlk3X3ON+:00000000000000000000000000000000000000ksD
X-Hashcash: 1:20:141229:akpm@linux-foundation.org::UyyYImpGfDV6Gvgl:0000000000000000000000000000000000001m87
X-Hashcash: 1:20:141229:s.strogin@partner.samsung.com::JK+o9FHXH+ENag5r:000000000000000000000000000000001Hdb
X-Hashcash: 1:20:141229:lauraa@codeaurora.org::Q95P9qwiPuPX+Wig:00000000000000000000000000000000000000001kZi
X-Hashcash: 1:20:141229:s.dyasly@samsung.com::wai3kdBkE/eq7YtU:000000000000000000000000000000000000000002ab3
X-Hashcash: 1:20:141229:minchan@kernel.org::DqlUuqwVGg5P7Y9i:00000000000000000000000000000000000000000002hbc
X-Hashcash: 1:20:141229:v.tyrtov@samsung.com::q71Mqt/R5u2UqsN1:000000000000000000000000000000000000000001+lJ
X-Hashcash: 1:20:141229:linux-kernel@vger.kernel.org::hNA+bIAA2cIpCXKq:0000000000000000000000000000000003FDh
X-Hashcash: 1:20:141229:iamjoonsoo.kim@lge.com::GJIvCGCF/jCFZdHh:0000000000000000000000000000000000000004Wjz
X-Hashcash: 1:20:141229:laurent.pinchart@ideasonboard.com::uBhJwDPzFw7zt5QI:00000000000000000000000000008QOm
X-Hashcash: 1:20:141229:stefan.strogin@gmail.com::ztHWvr6VhpAngeCx:0000000000000000000000000000000000000A6R8
X-Hashcash: 1:20:141229:pintu.k@samsung.com::Wingb8Zl2FmasJ5x:000000000000000000000000000000000000000000Eu8R
X-Hashcash: 1:20:141229:linux-mm@kvack.org::S0Jy3XdOujDHSrEO:0000000000000000000000000000000000000000000Em1N
Date: Mon, 29 Dec 2014 18:26:05 +0100
Message-ID: <xa1tbnmmgyfm.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Fri, Dec 26 2014, "Stefan I. Strogin" <s.strogin@partner.samsung.com> wrote:
>>> +		if (ret) {
>>> +			pr_warn("%s(): cma_buffer_list_add() returned %d\n",
>>> +				__func__, ret);
>>> +			cma_release(cma, page, count);
>>> +			page = NULL;

> On 12/26/2014 07:02 PM, Michal Nazarewicz wrote:
>> Harsh, but ok, if you want.

On Mon, Dec 29 2014, Stefan Strogin wrote:
> Excuse me, maybe you could suggest how to make a nicer fallback?
> Or sure OK?

I would leave the allocation succeed and print warning that the debug
information is invalid.  You could have a “dirty” flag which is set if
that happens (or on a partial release discussed earlier) which, if set,
would add “Some debug information missing” message at the beginning of
the procfs file.  In my opinion CMA succeeding is more important than
having correct debug information.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
