Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3AYCBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:01:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53507 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab3AYCBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:01:34 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-59-5101e77d6af9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, cpgs@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
 <1359035130-22667-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1359035130-22667-2-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH v2 1/2] usb: ehci-s5p/ohci-exynos: Fix compatible strings
 for the device
Date: Fri, 25 Jan 2013 11:01:32 +0900
Message-id: <00c501cdfa9f$e61a9be0$b24fd3a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac36ODbp1NP8O/+4SfmaxZchmI13zAAZvPHw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zA93a54yBBke+yVtc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlTH/4hbWggssFQtXd7I1MN5i7mLk5JAQMJE4
	MX0zE4QtJnHh3nq2LkYuDiGBZYwS+y9tZIMpOn6ulREisYhRYtnMaWDdQgK/GCU+TgLrZhNQ
	k/jy5TA7iC0i4CFx99hydpAGZoEOZon1vbOhxrYzSvx5dpgVpIpTwFPiwuw1QDYHh7BAnMTF
	vxEgYRYBVYkD93aBlfAK2Eoc2vqGCcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIGMkBNQl
	Hv3VhbjBSKJ9wmpWiBIRiX0v3oE9ICGwiV3i4PztbBC7BCS+TT7EAtErK7HpADRUJCUOrrjB
	MoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiJN6kdjCsb
	LA4xCnAwKvHwWqQxBgqxJpYVV+YeYpTgYFYS4XWJAArxpiRWVqUW5ccXleakFh9iTAY6diKz
	lGhyPjAV5JXEGxobm5iZmJqYW5qam5ImrCTOy3jqSYCQQHpiSWp2ampBahHMFiYOTqkGxkm/
	DFb+mmoeOfF5QrdVZpFZZ6HQnidCYlwHd2w+4ZwUGiivtdf5YdO3D3P43C/k9UiEb1BW2L2n
	7cKpgjj+91m5DCc037KvncD4gN9FZfneteEcPSceF/+7k9+9Z/UOKU3/vmrHy1/bRLa4Opio
	1m9yDlZ7/9hz79S4y/mXVy6zmirsYHx4mhJLcUaioRZzUXEiAMFRgZr7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd3a54yBBleuS1lc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5gx/+IW
	1oILLBULV3eyNTDeYu5i5OSQEDCROH6ulRHCFpO4cG89WxcjF4eQwCJGiWUzp4EVCQn8YpT4
	OIkJxGYTUJP48uUwO4gtIuAhcffYcnaQBmaBDmaJ9b2zobrbGSX+PDvMClLFKeApcWH2GiCb
	g0NYIE7i4t8IkDCLgKrEgXu7wEp4BWwlDm19wwRhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1b
	ZpAxEgLqEo/+6kLcYCTRPmE1K0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjOBofia1g3Flg8UhRgEORiUeXos0xkAh1sSy4srcQ4wSHMxK
	IrwuEUAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcmmrySeENjEzMjSyMzCyMTc3PShJXE
	eRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnVwCh8WU/tbAODWP8mDe/mCd9uv7fjEhWeIf1pu6l/
	+934fbdV551eE9Sio3xEe9n+F5f8l+mv481J8tSUyeph/7XE/EHS2aoILcvXO1/9tEsvm+my
	e2/lrNDue6abgxJePpLrNVs7N3WVwmTdK9bP17Sv6GHNqXjSIHBVusroppVsuu3veZEPopVY
	ijMSDbWYi4oTAauQ1OcqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 24, 2013 10:45 PM, Vivek Gautam wrote
> 
> Using specific chip in compatible strings. Newer SOCs can claim
> device by using older string in the compatible list.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/host/ehci-s5p.c    |    2 +-
>  drivers/usb/host/ohci-exynos.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 


