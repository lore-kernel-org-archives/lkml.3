Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3HGJJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:09:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44983 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab3HGJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:09:07 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-02-52020eb2189b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1375851375-5604-1-git-send-email-gshark.jeong@gmail.com>
In-reply-to: <1375851375-5604-1-git-send-email-gshark.jeong@gmail.com>
Subject: Re: [PATCH v3] backlight: lm3630: apply chip revision
Date: Wed, 07 Aug 2013 18:09:05 +0900
Message-id: <000001ce934d$c4b3ddd0$4e1b9970$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHlPrAeIGBs8MpcioPWknjc/OXhXZlcHZUA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY91NfExBBodPilvMWb+GzWLy7i5W
	i8sLLwGJXXPYLHbvesrqwOqxc9Zddo8TM36zeOyZ/4PVo2/LKkaPz5vkAlijuGxSUnMyy1KL
	9O0SuDKePFjFWnCSs+LdR5YGxnfsXYycHBICJhKTdrezQdhiEhfurQeyuTiEBJYxSqzdspAN
	pujFmolMEInpjBKTFk9nhnB+MUrsXnSJBaSKTUBN4suXw2BjRQSiJF6dOwdUxMHBLJAlcXRB
	LYgpJOAq8fGkNkgFp4CbxPtnTcwgtrCAnUT/sxawThYBVYlzM5vAJvIKWEpsXnGLGcIWlPgx
	+R5YnFlAS2L9zuNMELa8xOY1b5kh7lSQ2HH2NSPEBUYSbxuXQtWLSOx78Y4R5GQJgWvsEnPO
	bmKFWCYg8W3yIRaQ2yQEZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFy
	QXFSepGJXnFibnFpXrpecn7uJkZInE7YwXjvgPUhxmSg9ROZpUST84FxnlcSb2hsZmRhamJq
	bGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRjHezetOequ+iwtY+L7X
	Ivr65Gs8wjFvXzBdrTz3NbRs993Tws1VslMisvO7kvXYp/Ctvpkl43GL36Z7kV11oKDAQlvD
	pvy58zfePNPfX3L9kfDGSp9tlgb/NJ78yrO6veJPkNR5lqsLNHpKi+abP7+ZJ6n5YLP10+u7
	NlonfH2ivGzL14yyo0osxRmJhlrMRcWJAA/In2rpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1NfExBBnsOCFvMWb+GzWLy7i5W
	i8sLLwGJXXPYLHbvesrqwOqxc9Zddo8TM36zeOyZ/4PVo2/LKkaPz5vkAlijGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4C2KymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgznjxYxVpwkrPi3UeWBsZ37F2MnBwSAiYSL9ZM
	ZIKwxSQu3FvP1sXIxSEkMJ1RYtLi6cwQzi9Gid2LLrGAVLEJqEl8+XIYrFtEIEri1blzQEUc
	HMwCWRJHF9SCmEICrhIfT2qDVHAKuEm8f9bEDGILC9hJ9D9rAetkEVCVODezCWwir4ClxOYV
	t5ghbEGJH5PvgcWZBbQk1u88zgRhy0tsXvOWGeJOBYkdZ18zQlxgJPG2cSlUvYjEvhfvGCcw
	Cs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgJPBMagfjygaL
	Q4wCHIxKPLwVYoxBQqyJZcWVuYcYJTiYlUR4J7AyBQnxpiRWVqUW5ccXleakFh9iTAb6dCKz
	lGhyPjBB5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY6e+
	dkbCxGMMFy1q1gkk+j03XpDoWf1F30nXK7k9MLFh+Q+TkkhlZqlfV558c/5uyMGxq8W/w1ff
	dcbukFOWbs8VTuZfuSN462CRW8HUXc+vpy6YtMNf983CvHaWJ6eiApYKlhzLYHimfOOasE6E
	uPDcXA+WyUZnJ2SzxDSst87x+/3rVP0iJZbijERDLeai4kQA8fruW0YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 07, 2013 1:56 PM, Daniel Jeong wrote:
> 
> The LM3630 chip was revised by TI and chip name was also changed to LM3630A.
> And register map, default values and initial sequences are changed.
> The files, lm3630_bl.{c,h} are replaced by lm3630a_bl.{c,h}
> You can find more information about LM3630A(datasheet, evm etc)
> at http://www.ti.com/product/lm3630a
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>


Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/Kconfig          |    6 +-
>  drivers/video/backlight/Makefile         |    2 +-
>  drivers/video/backlight/lm3630_bl.c      |  475 -----------------------------
>  drivers/video/backlight/lm3630a_bl.c     |  483 ++++++++++++++++++++++++++++++
>  include/linux/platform_data/lm3630_bl.h  |   57 ----
>  include/linux/platform_data/lm3630a_bl.h |   65 ++++
>  6 files changed, 552 insertions(+), 536 deletions(-)
>  delete mode 100644 drivers/video/backlight/lm3630_bl.c
>  create mode 100644 drivers/video/backlight/lm3630a_bl.c
>  delete mode 100644 include/linux/platform_data/lm3630_bl.h
>  create mode 100644 include/linux/platform_data/lm3630a_bl.h

