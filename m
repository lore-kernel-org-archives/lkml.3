Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3H3AU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:20:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18280 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3H3AUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:20:25 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-9a-521fe547169f
Message-id: <521FE549.3080605@samsung.com>
Date: Fri, 30 Aug 2013 09:20:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        George Cherian <george.cherian@ti.com>, balbi@ti.com,
        myungjoo.ham@samsung.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob@landley.net, ian.campbell@citrix.com,
        mark.rutland@arm.com, pawel.moll@arm.co
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB ID
 detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com>
 <1376648029-30659-2-git-send-email-george.cherian@ti.com>
 <52127284.6030506@wwwdotorg.org> <521312CC.8060003@ti.com>
 <52139F0F.6090507@wwwdotorg.org> <52199663.8070201@roeck-us.net>
In-reply-to: <52199663.8070201@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkUNf9qXyQwfJ/JhYH79dbzD9yjtXi
	1MHlrBYH/uxgtHjT28FisbBtCYvF5V1z2CyeLDzDZLH0+kUmi9uNK9gs2nZdZbJY93I6i8Wr
	g20sDrwe/U+PMXmsmbeG0eP15AmMHq9Wz2T1uHNtD5vHzu8N7B59W1Yxehy/sZ3J4/MmOY+N
	c0MDuKK4bFJSczLLUov07RK4MvrenmMueMtS0TOxiamB8SlzFyMnh4SAicTaiW/ZIWwxiQv3
	1rN1MXJxCAksZZRYfmUCG0xR57etLBCJRYwS/9euYYJwXjFKTNkylxWkildAS+LgjF4mEJtF
	QFXi2/4VYHE2oPj+FzfAJokKhEmsnH6FBaJeUOLH5HtgtoiAmkTzqRawGmaBo0wSq25bdjFy
	cAgLREhcWKEAsauRSeLc7htgZ3MK6EjM3vGeGaJeR2J/6zSoXnmJzWveMoM0SAjM5JD4Ngli
	KIuAgMS3yYdYQIZKCMhKbDoA9b6kxMEVN1gmMIrNQnLSLCRjZyEZu4CReRWjaGpBckFxUnqR
	oV5xYm5xaV66XnJ+7iZGYIyf/vesdwfj7QPWhxiTgVZOZJYSTc4Hpoi8knhDYzMjC1MTU2Mj
	c0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAaXtReXT35eU8I00Ld+/t4
	bE4rr0t6G8Qz9fzEbXvjku/2XErZ+qDHy33X33t3cm8sWrVV9HlhLtuq2QHyMiqFm/W6Z0xM
	8f3J+22rDxfXx4eiqWe29V+xVegr3ninNP7Ua8M1PmcL507+x+L+pqMg1oK9sfpHrI1DlUqb
	csWq+MeH657VfvymxFKckWioxVxUnAgAJZXppgcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jAV33p/JBBmt+6VgcvF9vMf/IOVaL
	UweXs1oc+LOD0eJNbweLxcK2JSwWl3fNYbN4svAMk8XS6xeZLG43rmCzaNt1lcli3cvpLBav
	DraxOPB69D89xuSxZt4aRo/XkycwerxaPZPV4861PWweO783sHv0bVnF6HH8xnYmj8+b5Dw2
	zg0N4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	ATpeSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jR9/Ycc8FbloqeiU1M
	DYxPmbsYOTkkBEwkOr9tZYGwxSQu3FvP1sXIxSEksIhR4v/aNUwQzitGiSlb5rKCVPEKaEkc
	nNHLBGKzCKhKfNu/AizOBhTf/+IGG4gtKhAmsXL6FRaIekGJH5PvgdkiAmoSzadawGqYBY4y
	Say6bdnFyMEhLBAhcWGFAsSuRiaJc7tvgF3HKaAjMXvHe2aIeh2J/a3ToHrlJTavecs8gVFg
	FpIVs5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcAJ5Jr2DcVWDxSFGAQ5G
	JR7ehqnyQUKsiWXFlbmHGCU4mJVEeOO3AYV4UxIrq1KL8uOLSnNSiw8xJgNDYCKzlGhyPjC5
	5ZXEGxqbmBlZGpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDI+ejoA+Ppqpk
	r1vA/DrO6+Cs0n0y5ZNnn/72XW3eM7XXO1yZQ3655vrOsru2X6B8muGdjG6lBZf04s10X0Qr
	R3u6PC+IXXmv/dOyuPKu0FIJKdnjH+7aVf76NyX5yNb/K3ZUqGUzGvwrLNvU8vVq8dziZ878
	lfPfpfOciN4uPfNRyPTKtVMKkpRYijMSDbWYi4oTAfhnEyBkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> I am currently working on adding device tree support to the extcon-gpio driver.
> 
> Wonder if it would make sense to just use that driver. As far as I can see
> the only missing part is support for multiple cables and cable naming through
> device tree properties.
> 
> Any thoughts ? The patches are not yet clean enough to submit upstream,
> but I could send them as RFC if there is interest.
> 

I'm considering ways to use and update extcon-gpio driver.
I have interest concerning your approach.
After completing your work, send them as RFC as you mentioned.

Thanks,
Chanwoo Choi

