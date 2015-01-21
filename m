Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbbAUOSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:18:41 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33127 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbbAUOSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:18:34 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-31-54bfb4a643d3
Message-id: <54BFB535.6080200@partner.samsung.com>
Date: Wed, 21 Jan 2015 17:18:29 +0300
From: Stefan Strogin <s.strogin@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
MIME-version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        s.strogin@partner.samsung.com, stefan.strogin@gmail.com
Subject: Re: [PATCH 2/3] mm: cma: introduce /proc/cmainfo
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
 <264ce8ad192124f2afec9a71a2fc28779d453ba7.1419602920.git.s.strogin@partner.samsung.com>
 <54A1C37D.5000106@codeaurora.org>
In-reply-to: <54A1C37D.5000106@codeaurora.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t/xy7rLtuwPMWhbp2sxZ/0aNovHr+ex
	WHxa+ZTNYmV3M5vF9s4Z7BadE5ewW1zeNYfN4t6a/6wWa4/cZbdYcLyF1WLZ1/fsFn3fD7Nb
	TJ4tZfHt5Bxmi2s7+pksLr/5z24xdcYPdouTG86yWmxo5nIQ9rjc18vksXPWXXaP2R0zWT02
	repk89j0aRK7R9fbK0weJ2b8ZvF4cGgzi8e6P6+YPA6+28Pk0bdlFaPH501yHl0bf7EG8EZx
	2aSk5mSWpRbp2yVwZUx9w13Qxlqx8tcJtgbG38xdjJwcEgImErtmboGyxSQu3FvP1sXIxSEk
	sJRRouFUE5TzkVGiecIHVpAqXgEjiePPfrGD2CwCqhLnvv9iA7HZgCYduzCdEcQWFYiQmH/s
	NTNEvaDEj8n3WEBsEYEYiednPoANZRb4ySLx9OtNsISwgKXE+V2bobbtY5R4Ov8f2FROAT2J
	1y9vAm3mAOrQk7h/UQskzCwgL7F5zVvmCYwCs5DsmIVQNQtJ1QJG5lWMoqmlyQXFSem5RnrF
	ibnFpXnpesn5uZsYIZH6dQfj0mNWhxgFOBiVeHglfPaHCLEmlhVX5h5ilOBgVhLhNZ0AFOJN
	SaysSi3Kjy8qzUktPsTIxMEp1cDo886hLIbHl2frSX12sdqIU6vuvVjRFPcpaLX2P4Vy5qMa
	u/3MFrmdbmOerri2tER7Um7oyffGmxYkKB5MY/r7ebl/V37f1YvzN8wqEtW0rVGsTHp/OGWO
	1+VovYNdTd4S5YH2x5TWP/7MeXaCaNU9jd2Hswv//to0P8965fUD7cqBuy7PlPumxFKckWio
	xVxUnAgASS9XiLICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Laura,

On 30/12/14 00:11, Laura Abbott wrote:
>
> This seems better suited to debugfs over procfs, especially since the
> option can be turned off. It would be helpful to break it
> down by cma region as well to make it easier on systems with a lot
> of regions.
>
> Thanks,
> Laura
>

I thought that cmainfo is very similar to vmallocinfo, therefore put it
to procfs. However it seems I have no other choice than debugfs as Pavel
Machek wrote :-)
> We should not add new non-process related files in /proc.
(https://lkml.org/lkml/2015/1/2/6)

And thanks, I agree that breaking it down by CMA region would be useful.

