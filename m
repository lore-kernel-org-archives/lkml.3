Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbaJ3NAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:00:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40019 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaJ3NAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:00:01 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-f79b46d000002b74-38-5452364fbd7e
Content-transfer-encoding: 8BIT
Message-id: <5452364F.2070402@samsung.com>
Date: Thu, 30 Oct 2014 21:59:59 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] drm/exynos/dsi: remove global display variable
References: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
 <5452318C.1030107@samsung.com>
In-reply-to: <5452318C.1030107@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWyRsSkUNffLCjE4P4kKYtb686xWlz5+p7N
	4sW9iywWvQuuslmcbXrDbnF51xw2ixnn9zFZrD1yl91ixuSXbA6cHve7jzN59G1ZxejxeZNc
	AHMUl01Kak5mWWqRvl0CV8aaJS9ZCy5yVZw7toSlgfEMRxcjJ4eEgIlEz69+VghbTOLCvfVs
	XYxcHEICSxklXhzewghT9HLnHnaIxCJGid03fjGBJHgFBCV+TL7H0sXIwcEsIC9x5FI2SJhZ
	QF1i0rxFzCC2kMArRolFXRIQ5VoSx/99ZgexWQRUJRa+OMwGYrMB2RNX3AezRQXCJF682gXW
	KwI0Z/bJO8wge5kFpjJLXFjUwwKSEBZwl3i0eg0LxIIUiderfrGB3MApoC3R+JQDpF5C4BK7
	RM+EVcwQywQkvk0+BHanhICsxKYDzBB/SUocXHGDZQKj2Cwk38xC+GYWkm8WMDKvYhRNLUgu
	KE5KLzLSK07MLS7NS9dLzs/dxAiMudP/nvXtYLx5wPoQowAHoxIPr8aJwBAh1sSy4srcQ4ym
	QEdMZJYSTc4HRnZeSbyhsZmRhamJqbGRuaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2MYRG6rBdZNtw59CN5J+8y3+OR1zMN++VM5O7JKrLzBpyYfErSoGjBdvn5bacfvfT7
	nqJW/NxZ7PFcFotlet37ctdwr3ZcWOF1uj/qwwfBi9mWK5qD0pYuOsa2dtNS9y+PHqrqOu6W
	n3+TZS3ThKmXv3Kr7/x4d9XsF5z3YzwkL/9a92HxbfHrNUosxRmJhlrMRcWJAHyW3e+0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAV1/s6AQg+sThSxurTvHanHl63s2
	ixf3LrJY9C64ymZxtukNu8XlXXPYLGac38dksfbIXXaLGZNfsjlwetzvPs7k0bdlFaPH501y
	AcxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz1ix5yVpwkavi3LElLA2M
	Zzi6GDk5JARMJF7u3MMOYYtJXLi3nq2LkYtDSGARo8TuG7+YQBK8AoISPybfY+li5OBgFpCX
	OHIpGyTMLKAuMWneImYQW0jgFaPEoi4JiHItieP/PoPNZBFQlVj44jAbiM0GZE9ccR/MFhUI
	k3jxahdYrwjQnNkn7zCD7GUWmMoscWFRDwtIQljAXeLR6jUsEAtSJF6v+sUGcgOngLZE41OO
	CYwCs5BcNwvhullIrlvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziin0nvYFzVYHGI
	UYCDUYmHV+NEYIgQa2JZcWXuIUYJDmYlEd6jOkEhQrwpiZVVqUX58UWlOanFhxhNgZ6byCwl
	mpwPTDZ5JfGGxiZmRpZG5oYWRsbmSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoYPR7+YPUv
	fW5jNFUv+FqHRPZODdey+eH7vvzoy828Wdly8s4fg+f96jcfT7kdGcts9NBHaXqXwh/fPZsU
	GVfbtIUGzfp2rmCJ0YMP01dmTZD5yeiy9GKC2IGQvil6uamvOtqYzjw0/xaYPmv23xdRVgyq
	J5/YZJyKCDt0R//SU4vJD/c/1tT3V2Ipzkg01GIuKk4EACRbPRT+AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 30일 21:39, Andrzej Hajda wrote:
> On 10/07/2014 02:01 PM, Andrzej Hajda wrote:
>> Hi Inki,
>>
>> Many Exynos DRM drivers uses global variables to represent associated devices
>> in Exynos DRM internal framework. It is quite confusing, it adds data duplication
>> and finally it does not allow to handle more than one device in system.
>> It seems better to embed such structures in private context of the device.
> 
> Gently ping.

This patch series already is in exynos-drm-next-todo branch. I will move
it to exynos-drm-next after checking.

Thanks,
Inki Dae

> 
> Regards
> Andrzej
> 
>>
>> The patchset is based on exynos_drm_next plus my patch [1]:
>> 'drm/exynos: remove explicit encoder/connector de-initialization'.
>>
>> If the patchset is OK for you I can prepare similar patches for other Exynos DRM components.
>>
>> [1]: https://lkml.org/lkml/2014/9/22/148
>>
>> Regards
>> Andrzej
>>
>>
>> Andrzej Hajda (4):
>>   drm/exynos/dsi: remove global variable exynos_dsi_display
>>   drm/exynos/dsi: simplify device pointer evaluation
>>   drm/exynos/dsi: remove redundant encoder field
>>   drm/exynos/dsi: stop using display->ctx pointer
>>
>>  drivers/gpu/drm/exynos/exynos_drm_dsi.c | 96 ++++++++++++++++-----------------
>>  1 file changed, 47 insertions(+), 49 deletions(-)
>>
> 
> 

