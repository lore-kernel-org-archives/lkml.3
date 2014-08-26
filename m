Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbaHZGwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:52:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36631 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHZGww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:52:52 -0400
X-AuditID: cbfee691-f79546d0000011a1-5b-53fc2ec1b1a2
Message-id: <53FC2EC2.2030204@samsung.com>
Date: Tue, 26 Aug 2014 15:52:50 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 00/15] drm/exynos/ipp: image post processing fixes and
 improvements, part four
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWyRsSkWPeg3p9gg9m/NCxurTvHanHl63s2
	i0n3J7BYvLh3kcXibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDKuXfzJXtDHW/H2xhqmBsZzXF2MnBwSAiYS8ybeYIawxSQu3FvP
	1sXIxSEksJRRomvJETaYosnXV7OA2EIC0xklWvpEIIpeMUpMu/8drIhXQEvi5JMF7CA2i4Cq
	xMzeBrCpbAJ6Ene2HWcCsUUFQiTeHG9nh6gXlPgx+R7YUBEBD4n5b/aA1TMLnGGS+LpeF8QW
	FkiRmLF0ExvEYmeJrtvTwOZwCrhIXDg4DaieA6heT+L+RS2IVnmJzWveMoPcJiFwjF1i4eLp
	zBD3CEh8m3yIBaReQkBWYtMBqIclJQ6uuMEygVFsFpKLZiFMnYVk6gJG5lWMoqkFyQXFSelF
	pnrFibnFpXnpesn5uZsYgTF3+t+ziTsY7x+wPsQowMGoxMN7I/53sBBrYllxZe4hRlOgIyYy
	S4km5wMjO68k3tDYzMjC1MTU2Mjc0kxJnFdH+mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BkbPv5e+NQm/E7r9Rf7RgVNnF9/I1oivKqt81hS+RlKoPehB9uJlJzfxLeT0e6nxNM8yj13w
	/CPls0Kv5PZ8FzPatePsJdPXPApdPz790rMt/5Z7OmDmwtqvp94UvW8WfyNjqCdgmBweKfXM
	MTFojUONzKY1Oesa76s8/P8wRrzWf5GgoqfFtzVKLMUZiYZazEXFiQCbpJaAtAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd2Den+CDf4dV7S4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYce3iT/aCPt6KtzfWMDUw
	nuPqYuTkkBAwkZh8fTULhC0mceHeejYQW0hgOqNES59IFyMXkP2KUWLa/e9gCV4BLYmTTxaw
	g9gsAqoSM3sbmEFsNgE9iTvbjjOB2KICIRJvjrezQ9QLSvyYfA9sgYiAh8T8N3vA6pkFzjBJ
	fF2vC2ILC6RIzFi6CWqxs0TX7WlgczgFXCQuHJwGVM8BVK8ncf+iFkSrvMTmNW+ZJzAKzEKy
	YRZC1SwkVQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf0M6kdjCsbLA4xCnAwKvHw
	3oj/HSzEmlhWXJl7iFGCg1lJhJfhIVCINyWxsiq1KD++qDQntfgQoynQ/xOZpUST84HJJq8k
	3tDYxMzI0sjc0MLI2FxJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA6OZyJ+oG9sWyz9KT5J8
	paHlwXylR2lHSKWMieklLuNlVVxnJTg+5N4quGom/cHSOmLHw7og339iWe56nh/jTALPVdgs
	uCI0385uJkfHu1zHvmrfuGbmkzlnNLTVFnAZKv/zlOfvU7Dq/znlpbSMm91N7edHNpY4Suqo
	cffKfWT47rb8pLOoEktxRqKhFnNRcSIATNlpBP4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
> This set of patches contains various improvement and fixes
> for exynos_drm ipp framework.
> The patchset is based on exynos-drm-next branch.
> 
> IPP framework was tested for regressions on exynos4210-trats target.
> 
> Regards
> Andrzej
> 
> 
> Andrzej Hajda (15):
>   drm/exynos/ipp: remove fake pm callbacks
>   drm/exynos/ipp: cancel works before command node clean
>   drm/exynos/ipp: move file reference from memory to command node
>   drm/exynos/ipp: remove only related commands on file close
>   drm/exynos/ipp: remove unused field in command node
>   drm/exynos/ipp: free partially allocated resources on error
>   drm/exynos/ipp: move nodes cleaning to separate function
>   drm/exynos/ipp: clean memory nodes on command node cleaning
>   drm/exynos/ipp: replace work_struct casting with better constructs
>   drm/exynos/ipp: stop hardware before freeing memory
>   drm/exynos/ipp: remove events during command cleaning
>   drm/exynos/fimc: avoid clearing overflow bits
>   drm/exynos/fimc: do not enable fimc twice
>   drm/exynos/fimc: simplify buffer queuing
>   drm/exynos/fimc: fix source buffer registers

With some minor comments,

Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>

Thanks.

> 
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c    |  90 ++-----
>  drivers/gpu/drm/exynos/exynos_drm_gsc.c     |   3 +-
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c     | 369 ++++++++++++----------------
>  drivers/gpu/drm/exynos/exynos_drm_ipp.h     |   4 +-
>  drivers/gpu/drm/exynos/exynos_drm_rotator.c |   3 +-
>  5 files changed, 180 insertions(+), 289 deletions(-)
> 

