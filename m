Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaEFXni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:43:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50016 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaEFXng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:43:36 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-f9-536973a11aba
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Viresh Kumar'" <viresh.kumar@linaro.org>, "'Nishanth Menon'" <nm@ti.com>
Cc: "'Linux PM list'" <linux-pm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Len Brown'" <len.brown@intel.com>,
        "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
 <CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
 <003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
 <CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
 <5367946F.1030407@ti.com>
 <CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
 <CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
 <CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
In-reply-to: <CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
Subject: RE: [PATCH 1/3] PM / OPP: Add support for descending order for cpufreq
 table
Date: Wed, 07 May 2014 08:43:29 +0900
Message-id: <003e01cf6984$fb950280$f2bf0780$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIqe0fjYa0YwQL6oKQ2dX7E8rarYwGe0UWzAg3L9n0CFbDXrQI73VqNAJ+GCpEBnU9akQFwpfDYmiC0acA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY92FxZnBBn/vKFg0XA2xmDVlL5PF
	5V1z2Cw+9x5htHjz4yyTxZnTl1gtNn71cGD3WLznJZPHnWt72Dy2XG1n8ejbsorR4/iN7Uwe
	nzfJBbBFcdmkpOZklqUW6dslcGVsX3iWqWA+V0X7uuMsDYxTOLoYOTkkBEwkLl05xAphi0lc
	uLeerYuRi0NIYBmjxJFDqxhhiiYtf8cEkVjEKPHmwU0o5x+jRGPbayaQKjYBXYlj67eAjRIR
	8JL4sfoE2ChmgfuMEv/PvYaa+4JZYt+XbcwgVZwCwRLzNq9hB7GFBcIl1qybCTaJRUBV4szB
	qWC7eQUsJX58nsgOYQtK/Jh8jwXEZhZQl5g0bxEzhK0t8eTdBagnFCR2nH3NCHFFisSf9ueM
	EDUiEvtevIP65yO7xJwPXBC7BCS+TT4ENJMDKC4rsekAM0SJpMTBFTdYJjBKzEKyeRaSzbOQ
	bJ6FZMMCRpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCGR3LuD8fYB60OMyUDrJzJLiSbn
	AxNBXkm8obGZkYWpiamxkbmlGWnCSuK8SQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	+jTJTStZu++IlvjqNZLHHh+P861e4/44fJqjG5fbJJvsGV76ii+Dnx/ctK/k3En7R6bdimuD
	985Y//Trnf4z36oTPD57d38+5ctx8e0rhuNb5DPOtlw9JGVk8mXFcSXpi6siJbeoOz68WSdc
	v90q4VHxXq297JwmR26534s+1PJGas1xyS8ZkUosxRmJhlrMRcWJAMfcPzP6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jAd2FxZnBBt/bZSwaroZYzJqyl8ni
	8q45bBafe48wWrz5cZbJ4szpS6wWG796OLB7LN7zksnjzrU9bB5brrazePRtWcXocfzGdiaP
	z5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbF94lqlgPldF+7rj
	LA2MUzi6GDk5JARMJCYtf8cEYYtJXLi3nq2LkYtDSGARo8SbBzeZIJx/jBKNba/BqtgEdCWO
	rd/CCmKLCHhJ/Fh9AqyDWeA+o8T/c6+h2l8wS+z7so0ZpIpTIFhi3uY17CC2sEC4xJp1M8Em
	sQioSpw5OJURxOYVsJT48XkiO4QtKPFj8j0WEJtZQF1i0rxFzBC2tsSTdxdYIW5VkNhx9jUj
	xBUpEn/anzNC1IhI7HvxjnECo9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIThTPpHYwrmywOMQowMGoxMNr8TYjWIg1say4MvcQowQHs5II703dzGAh3pTE
	yqrUovz4otKc1OJDjMlAn05klhJNzgcmsbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYDxl4XncwoX5vTGL3F3Ddxt+rOfUWnF934b4+R+uV4Yn/8ji8S1l
	CdzNk2s9s/uzW9Y1zjIe3+tvH80+YuvgsiOvuVZ1tevm5RNCm82btcUPvOe1WxupsJN/wjd/
	kQcT5G65yZVvrnpm/20uI5u/3dElx3tePkj9yJLtuFSnSCLL5X/hC7sbf5RYijMSDbWYi4oT
	AQBTy2tYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  

My holiday is finished.

I implemented another cpufreq driver. And that driver also have to use exynos_sort_descend_freq_table().
Then exynos5440 and new cpufreq have a duplicate function.(exynos_sort_descend_freq_table().
So I want to solve it.

Thanks.~

> -----Original Message-----
> From: Viresh Kumar [mailto:viresh.kumar@linaro.org]
> Sent: Monday, May 05, 2014 11:39 PM
> To: Nishanth Menon
> Cc: Jonghwan Choi; Linux PM list; open list; Rafael J. Wysocki; Len Brown;
> Amit Daniel Kachhap
> Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
> cpufreq table
> 
> On 5 May 2014 19:53, Nishanth Menon <nm@ti.com> wrote:
> > ceil and floor allows us to walk down the opp entries the direction we
> > want it to.
> > one can convert that data any way one wants it - especially when
> > custom mapping such as this is desired.
> 
> Yeah, but doing that for every frequency transition is not right.
> Otherwise they already have a solution, where they reverse order of
> frequencies for their driver. exynos_sort_descend_freq_table().
> 
> Probably that's a better solution then :)
> 
> But, Jonghwan was probably trying to get this solved in the framework only,
> in case anybody else needs it.
> 
> --
> viresh

