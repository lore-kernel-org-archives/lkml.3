Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaJ0PUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:20:31 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31042 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaJ0PUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:20:30 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-a8-544e62b721f3
Content-transfer-encoding: 8BIT
Message-id: <544E62B5.8060603@samsung.com>
Date: Mon, 27 Oct 2014 16:20:21 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        Thierry Reding <treding@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] MAINTAINERS: Add entry for MIPI DSI bus
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
 <1414403310-6316-2-git-send-email-a.hajda@samsung.com>
 <20141027141717.GN26941@phenom.ffwll.local>
In-reply-to: <20141027141717.GN26941@phenom.ffwll.local>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t/xa7rbk/xCDKZsYrY4cX0Rk8WVr+/Z
	LC7vmsNmcfs3nwOLx85Zd9k97ncfZ/LobX7H5vF5k1wASxSXTUpqTmZZapG+XQJXxp3vU5kK
	pvNW7Nv6kbWB8QJXFyMnh4SAicT1g1cYIWwxiQv31rOB2EICSxklXs6vA7F5BQQlfky+x9LF
	yMHBLCAvceRSNoSpLjFlSm4XIxdQ9SdGia0zT7FClGtJPN73mwXEZhFQlbi77xcTiM0moCnx
	d/NNsPGiAhESV9bMYQRpFhGYyigxae5qsCJhAQeJ7kOToG5YySix4Ug5iM0pYCHxcGo38wRG
	/llITpqFcNIshJMWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJzi87GBcfszrEKMDB
	qMTDu2Oab4gQa2JZcWXuIUYJDmYlEd5TAX4hQrwpiZVVqUX58UWlOanFhxiZODilGhhrmn9v
	emmw3KLrTqTs7bnzlzyZefq3386rPKv6T3vVXd7eKbNzUU55vf97N84ld0IWnxdULpvcP01z
	l7ztBKF1+4rzjjlf2GgnNan1RoeXfYoC4753CYE6czwFGXd23JTonqJ+wpf7o+ry/znL3/Sl
	Fee86y1c8X/Sfr0Vu6N+CT2OmC7Df8xaiaU4I9FQi7moOBEAEPwCViwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 03:17 PM, Daniel Vetter wrote:
> On Mon, Oct 27, 2014 at 10:48:26AM +0100, Andrzej Hajda wrote:
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> ---
>>  MAINTAINERS | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index dd31933..476679c 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3071,6 +3071,13 @@ F:	drivers/gpu/vga/
>>  F:	include/drm/
>>  F:	include/uapi/drm/
>>  
>> +DRM MIPI DSI BUS
>> +M:	Andrzej Hajda <a.hajda@samsung.com>
>> +L:	dri-devel@lists.freedesktop.org
>> +S:	Supported
>> +F:	drivers/gpu/drm/drm_mipi_dsi.c
>> +F:	include/drm/drm_mipi_dsi.h
> 
> I really prefer when common infrastructure like this doesn't get
> maintainer by a vendor. And I care with my intel hat on since we also ahve
> a dsi driver that sooner or later needs to be converted to to this stuff.
> 
> Why doesn't the usual model of merging stuff through Dave's tree, or if
> that doesn't work well due to patch depencies, through vendor trees with
> Dave's ack?

The main intention of this patch is to be on CC in case of patches
touching MIPI DSI bus.
I do not want to create separate tree for such small subsystem.

So if such things are not allowed please drop the patch and sorry for
the noise.

Regards
Andrzej

> 
> Thanks, Daniel
> 
>> +
>>  RADEON DRM DRIVERS
>>  M:	Alex Deucher <alexander.deucher@amd.com>
>>  M:	Christian König <christian.koenig@amd.com>
>> -- 
>> 1.9.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

