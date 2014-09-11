Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaIKMub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:50:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57118 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaIKMu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:50:26 -0400
X-AuditID: cbfee68e-f79536d000000fd1-47-54119a90c4e2
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <54119A90.7080107@samsung.com>
Date: Thu, 11 Sep 2014 21:50:24 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v2 00/17] drm/exynos/ipp: image post processing fixes and
 improvements, part four
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkQHfCLMEQg0WfzS1urTvHanHl63s2
	ixf3LrJYnG16w25xedccNosZ5/cxWaw9cpfdYsbkl2wOHB73u48zefRtWcXo8XmTXABzFJdN
	SmpOZllqkb5dAlfG7JPfWQo+81dsnHiCuYHxDU8XIyeHhICJxNMXXcwQtpjEhXvr2boYuTiE
	BJYySuxZ8pcRpmhdw2QWiMQiRokV266xgyR4BQQlfky+xwJiMwuoS0yat4gZwhaReHB1ExOE
	rS2xbOFrZojmV4wSm1eeYYZo1pLYdrIbzGYRUJX4MrMVrIENyJ644j4biC0qECbx4tUusBoR
	oAWzT94BG8QscIZJ4uSBNWDnCQukS8w/+wWsWUjAWWL3+c9gNqeAi8TG42/YQRokBI6xSyz8
	t50VYpuAxLfJh4DO5gBKyEpsOgD1v6TEwRU3WCYwis9C8twsJM/NQvLcLCTPLWBkWcUomlqQ
	XFCclF5kpFecmFtcmpeul5yfu4kRGKGn/z3r28F484D1IUYBDkYlHt4KFsEQIdbEsuLK3EOM
	pkAXTWSWEk3OB6aBvJJ4Q2MzIwtTE1NjI3NLMyVx3gSpn8FCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGMt+Tkgr/3DF4afPxqJGjawjSYZd7p7KH07nP/vJ8UJ1onzonl8fNls83F8wSW7K
	NGMjtzKXGKUpEbemPf78tluquK3HI5kh4fS8bSdeOkxi2mI6d06Ns9cFG8uLFUd/OHv9zz/Z
	k3g1yuDpNmW5P5p5i5bv8bW2/Snx/kPf1RXPp6++9u3TNxMlluKMREMt5qLiRAABEPiwywIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAd0JswRDDJ7/0Le4te4cq8WVr+/Z
	LF7cu8hicbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7I5cHjc7z7O5NG3ZRWjx+dNcgHMUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM7af/cZU8JC/ovnmWvYGxls8XYyc
	HBICJhLrGiazQNhiEhfurWfrYuTiEBJYxCixYts1dpAEr4CgxI/J94CKODiYBeQljlzKBgkz
	C6hLTJq3iBmi/hWjxOaVZ5gh6rUktp3sBrNZBFQlvsxsZQKx2YDsiSvus4HYogJhEi9e7QKr
	EQEaNPvkHbBBzAJnmCROHljDCJIQFkiXmH/2C1izkICzxO7zn8FsTgEXiY3H37BPYBSYheS+
	WQj3zUJy3wJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbH8THoH46oGi0OMAhyMSjy8
	lSyCIUKsiWXFlbmHGCU4mJVEeG9MBwrxpiRWVqUW5ccXleakFh9iNAX6biKzlGhyPjDN5JXE
	GxqbmBlZGpkbWhgZmyuJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYNR4Iq9iO8HU09ghYO6R
	RUYapTni3st3Cqt90JJZ3acz++ljW6H17UdVH//tNXJ7G/Y4UtEt7pThzNeazAyBeq92KR15
	mJTUp6XxZdVjQ7GZqVs9jhx5JFysOD9X/Upp9YXb74zb2ha86Ht15EDJhvMreE/7JmXk661N
	rAjeUBnsJ1txUuj6NSWW4oxEQy3mouJEABpiE1j7AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 08월 28일 18:07, Andrzej Hajda wrote:
> This set of patches contains various improvement and fixes
> for exynos_drm ipp framework.
> The patchset is based on exynos-drm-next branch.
> 
> IPP framework was tested for regressions on exynos4210-trats target.
> 
> In the 2nd version of the series I have included changes proposed by Joonyoung Shim.
> I have decided to resend whole series because the changes caused merge conflicts and
> two separate patches have been added to the series.
> Changes are described in comit messages.

Applied.

Thanks,
Inki Dae

> 
> Regards
> Andrzej
> 
> 
> Andrzej Hajda (17):
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
>   drm/exynos/ipp: remove file argument from node related functions
>   drm/exynos/ipp: add file checks for ioctls
> 
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c    |  90 ++-----
>  drivers/gpu/drm/exynos/exynos_drm_gsc.c     |   3 +-
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c     | 397 ++++++++++++----------------
>  drivers/gpu/drm/exynos/exynos_drm_ipp.h     |   4 +-
>  drivers/gpu/drm/exynos/exynos_drm_rotator.c |   3 +-
>  5 files changed, 195 insertions(+), 302 deletions(-)
> 

