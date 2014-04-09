Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbaDIKaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:30:55 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62808 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaDIKax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:30:53 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-60-5345215bfc08
Message-id: <53452157.9030203@samsung.com>
Date: Wed, 09 Apr 2014 12:30:47 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, rahul.sharma@samsung.com
Subject: Re: [PATCHv2 2/3] drm: exynos: hdmi: use hdmiphy as PHY
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
 <1396967856-27470-3-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1396967856-27470-3-git-send-email-t.stanislaws@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xa7rRiq7BBufeGFvMP3KO1eLK1/ds
	Fgf+7GC06F1wlc3iwtMeNouzTW/YLS7vmsNm0bNhK6vFjPP7mCymLDrMatG69wi7xbzPO5ks
	5rW/ZHXg9dg56y67x6ZVnWwed67tYfO4332cyaNvyypGj+M3tjN5fN4kF8AexWWTkpqTWZZa
	pG+XwJXx9V0nU8EcloqXF6czNTCuZO5i5OSQEDCRmPptHROELSZx4d56ti5GLg4hgaWMEotv
	/mOGcD4xSrQ9fs8CUsUroCXRs2IDkM3BwSKgKtH8yxIkzCagKfF38002EFtUIELiXuNhVohy
	QYkfk++xgMwREbjMKLFszhJ2EIdZYA2jxOwVS8E6hAUcJDYv/8oEsa2dUWLduylg7ZwCnhJT
	ju8D28wsoCOxv3UaG4QtL7F5zVvmCYwCs5BsmYWkbBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OL
	S/PS9ZLzczcxQmLn6w7GpcesDjEKcDAq8fAqWLoEC7EmlhVX5h5ilOBgVhLhfc7mGizEm5JY
	WZValB9fVJqTWnyIkYmDU6qB8XzmdNn9W/cVidRW7vy5YHXt1HfHJ9W1VtVdSczM3/XLsq5t
	v/qEux+/3j/qeODhL1meal736atyxeV3flq2m6l+EttRvisu3JZp3850PnziemJP4IRpPZPP
	P3yjZPMxdY/9XE+FaCHvHyHyK9q4q1ZUWtfYZxlPvMmWN+u/yVT5lq40xk4mMyWW4oxEQy3m
	ouJEAGpKjs97AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/08/2014 04:37 PM, Tomasz Stanislawski wrote:
> The HDMIPHY (physical interface) is controlled by a single
> bit in a power controller's regiter. It was implemented
> as clock. It was a simple but effective hack.

This power controller register has also bits to control HDMI clock
divider ratio. I guess current drivers do not change it, but how do you
want to implement access to it if some HDMI driver in the future will
need to change ratio. I guess in case of clk it would be easier.

Regards
Andrzej


