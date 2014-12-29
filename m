Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaL2F4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 00:56:47 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63264 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaL2F4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 00:56:46 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-8f-54a0ed1bcccd
Message-id: <54A0ED19.1040003@partner.samsung.com>
Date: Mon, 29 Dec 2014 08:56:41 +0300
From: Safonov Dmitry <d.safonov@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: SeongJae Park <sj38.park@gmail.com>,
        "Stefan I. Strogin" <s.strogin@partner.samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 3/3] cma: add functions to get region pages counters
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
 <dfddb08aba9a05e6e7b43e9861ab09b7ac1c89cd.1419602920.git.s.strogin@partner.samsung.com>
 <alpine.DEB.2.10.1412271616450.1819@hxeon>
In-reply-to: <alpine.DEB.2.10.1412271616450.1819@hxeon>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xa7rSbxeEGPxt1beYs34Nm8Xj1/NY
	LD6tfMpmsbK7mc1ie+cMdovOiUvYLS7vmsNmcW/Nf1aLtUfuslssON7CarHs63t2i77vh9kt
	Js+Wsvh2cg6zxbUd/UwWU2f8YLc4ueEsq8WGZi4HIY/Lfb1MHjtn3WX3mN0xk9Vj06pONo9N
	nyaxe3S9vcLkcWLGbxaPB4c2s3is+/OKyePguz1MHn1bVjF6fN4k59G18RdrAG8Ul01Kak5m
	WWqRvl0CV8bLgweYC+YxVtxeeZ29gbGyi5GTQ0LAROL85h/sELaYxIV769m6GLk4hASWMkrc
	ebyAEcL5yCgxfeIZVpAqXgEjidfPe5lAbBYBVYlXnb1AcQ4ONqBJ85pjQMKiAhESH1Z9ZYMo
	F5T4MfkeC4gtIhAn0fj2KxPITGaBgywSz7p2gM0RFvCQ2Hz1EdTm44wSneffgp3EKWAucXPX
	L7BuZgFbiQXv10HZ8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1NLmgOCk910ivODG3uDQv
	XS85P3cTIyRCv+5gXHrM6hCjAAejEg9vwokFIUKsiWXFlbmHGCU4mJVEeI3KgEK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYtVf8/nt875YQXZVM+8oldb5F6xfor69b+NW8rG/lhlfsdje4Mq73
	50j0RPnU/K6fdfyroEag2cYn7xwbGOd9MNj7SUci50rEV13TRxYB6v47EoxqCx0NnD9Id7PN
	fbGrpTL0kmtC+LTf/2cp/DghxNhWY556vI1Z9NeD4wvYm2SD+m86hgUqsRRnJBpqMRcVJwIA
	WuCKt64CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/27/2014 10:18 AM, SeongJae Park wrote:
> Hello,
>
> How about 'CMA Region' rather than 'CMARegion'?
Sure.

-- 
Best regards,
Safonov Dmitry.

