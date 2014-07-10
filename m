Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbaGJEXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 00:23:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26610 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaGJEXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 00:23:46 -0400
X-AuditID: cbfee690-b7fb56d000003439-77-53be154f20ea
Message-id: <53BE1550.3060608@samsung.com>
Date: Thu, 10 Jul 2014 13:23:44 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: gregkh@linuxfoundation.org,
        "Marek Szyprowski/Poland R&D Center-Linux (MSD)/./????" 
	<m.szyprowski@samsung.com>,
        broonie@linaro.org, tobetter@gmail.com,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 0/3] usb: fix and support PM for usb3503
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkSNdfdF+wwd4HRhabrl9ntWhevJ7N
	4sW9iywWl3fNYbNYtKyV2WLtkbvsFvser2F2YPfYOesuu8eda3vYPPbPXcPu0bdlFaPH501y
	AaxRXDYpqTmZZalF+nYJXBmnpu1hLNjEXDFr8TymBsYLTF2MnBwSAiYSjU872SFsMYkL99az
	dTFycQgJLGWUmD/1F2MXIwdY0aQT5RDx6YwS57efB2sWEnjFKPHlvDJIDa+AlsSVBlkQk0VA
	VaLhkjVIBZuAnsSdbcfBqkUFwiSmnrjKAmLzCghK/Jh8D8wWEYiU6Hr7FGwts8ApRonf5z4z
	gySEBSwklt/aB2YzC+hI7G+dxgZhy0tsXvOWGaRBQmAXu8TrH1vAEiwCAhLfJh9igbhZVmLT
	AWaIvyQlDq64wTKBUWQWkt2zkIydhWTsAkbmVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxiB
	MXT637MJOxjvHbA+xJgMtHIis5Rocj4wBvNK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQkJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgXGiQOv5RbMXzNHd1m026/faj4s/TrZpiF7p/1Fk8pLX
	X9UrMzeszttSX3Vpo5KiP/OnmkPRBwK7T28/I7FXj7fjqfkPw5fKx9anccbNPNq8+37VqQSh
	S4WSk3buzLt86M+ksOI5Le+4Agt+Hz6gUKHjqXT7UIz4QuOsVsfohzNVkraa7Yut4cxRYinO
	SDTUYi4qTgQA3IHK8bcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQV1/0X3BBlt2aFtsun6d1aJ58Xo2
	ixf3LrJYXN41h81i0bJWZou1R+6yW+x7vIbZgd1j56y77B53ru1h89g/dw27R9+WVYwenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMODVtD2PBJuaKWYvnMTUw
	XmDqYuTgkBAwkZh0oryLkRPIFJO4cG89WxcjF4eQwHRGifPbzzOBJIQEXjFKfDmvDFLPK6Al
	caVBFsRkEVCVaLhkDVLBJqAncWfbcbBqUYEwiaknrrKA2LwCghI/Jt8Ds0UEIiW63j4FG88s
	cIpR4ve5z8wgCWEBC4nlt/aB2cwCOhL7W6exQdjyEpvXvGWewMg3C8msWUjKZiEpW8DIvIpR
	NLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOEKfSe9gXNVgcYhRgINRiYe3oWdvsBBrYllxZe4h
	RgkOZiURXo//QCHelMTKqtSi/Pii0pzU4kOMpkCfTmSWEk3OByaPvJJ4Q2MTMyNLI3NDCyNj
	cyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjHNOCMq/tRa0tKxS1V5crNB16U/r4iNnPoSd
	/SazqeFR6guuM3lPYs/UhATs2bKMad9d2Z8G+/dmc5hJ5jHdZGFk+h/Y7VfDEWPte1vnV9eU
	beGXPYKTphzvfL7/eozNj0u7Yl8xVL6f4Pgl+WjbvHP9hj2Bjj/KJOxPbFyw/P4ZaxXbU6tP
	fFZiKc5INNRiLipOBACa7dT65gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is simple just to fix and support PM for usb3503. They was
tested on odroid U3 board.

Thanks.

Joonyoung Shim (3):
      usb: usb3503: fix build warning
      usb: usb3503: add PM functions
      USB: add reset resume quirk for usb3503

 drivers/usb/core/quirks.c  |  3 +++
 drivers/usb/misc/usb3503.c | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 3 deletions(-)
