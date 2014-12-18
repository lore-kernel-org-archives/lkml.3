Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaLRTVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:21:43 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40260 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaLRTVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:21:40 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, m.szyprowski@samsung.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] CMA: add the amount of cma memory in meminfo
In-Reply-To: <548E3B5E.6050805@huawei.com>
Organization: http://mina86.com/
References: <547FCCE9.2020600@huawei.com> <xa1ty4qm9eq7.fsf@mina86.com> <548E3B5E.6050805@huawei.com>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.3 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141218:iamjoonsoo.kim@lge.com::klAVN1M+tkUj+l1+:0000000000000000000000000000000000000000vPz
X-Hashcash: 1:20:141218:aneesh.kumar@linux.vnet.ibm.com::dsVMyhBOiYdx8g2t:0000000000000000000000000000000zhT
X-Hashcash: 1:20:141218:qiuxishi@huawei.com::U1PGs6ILQrSGcXRH:0000000000000000000000000000000000000000000dLx
X-Hashcash: 1:20:141218:linux-kernel@vger.kernel.org::cIUpsvPsG221fnX9:0000000000000000000000000000000001Nyh
X-Hashcash: 1:20:141218:akpm@linux-foundation.org::lFpDYIrcHpQo9deU:0000000000000000000000000000000000001VEZ
X-Hashcash: 1:20:141218:m.szyprowski@samsung.com::EScQNrp/lyzXZ/fv:00000000000000000000000000000000000001Va7
X-Hashcash: 1:20:141218:linux-mm@kvack.org::EzYacIfAIbq1uqQ4:00000000000000000000000000000000000000000006HHn
Date: Thu, 18 Dec 2014 20:21:31 +0100
Message-ID: <xa1tegrwsr0k.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15 2014, Xishi Qiu <qiuxishi@huawei.com> wrote:
> The "mere white-space change" you said a few days ago，how about change like this
> ", nid, K(...)" -> ",nid, K(xxx)"?

If space is all you're changing, I wouldn't change it.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
