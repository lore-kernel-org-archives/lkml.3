Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaDYKQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:16:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51819 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaDYKQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:16:34 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-0b-535a3600526f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org
Subject: [PATCH 0/5] iio: exynos_adc: fix minor nits in the driver
Date: Fri, 25 Apr 2014 15:44:42 +0530
Message-id: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWyRsSkWpfRLCrY4GQ/k8XLQ5oWZ5cdZLNo
	XryezeLVkR9MFksmz2e1mHfkHYvF5V1z2CxmnN/HZLFo239mB06P2Q0XWTx2zrrL7rF/7hp2
	jyVvDrF69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8a5truMBSs4K6Yun8jWwHiZvYuRk0NC
	wESi88d/VghbTOLCvfVsXYxcHEICSxklTjSsZoEp+vj1HyOILSQwnVGiZ4E7hN3PJHG4QQTE
	ZhMwkzi4aDXQUA4OEQFZiZndeiBzmAUuMEr8/DIBbIGwgJPExv3/2EBqWARUJVb2y4CYvAIu
	Ej1fpUBMCQEFiTmTbEA6JQSms0tMvn2SCaSTRUBA4tvkQywQNbISmw4wQxwmKXFwxQ2WCYyC
	CxgZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIEhvLpf8/6dzDePWB9iDEZaNxEZinR5Hxg
	LOSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYO
	FhPPqKCMScKPklnErdnZQky8b1yJuNfbrBe++GbkUt5LHN3hlSUJM1+ZaXBukdr9KuGNxszT
	Oqc/3lrOuWlVtg3vGYuvfleXHH7M4bok1Xpj4PSiqvc3phfdsWLeqa72T9380dQv9oGCmZdl
	b04yPiCYcfL9JSmNIG6FqusyD/KCVCz/bFZiKc5INNRiLipOBADepL/FewIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t9jQV0Gs6hgg8dzzSxeHtK0OLvsIJtF
	8+L1bBavjvxgslgyeT6rxbwj71gsLu+aw2Yx4/w+JotF2/4zO3B6zG64yOKxc9Zddo/9c9ew
	eyx5c4jVo2/LKkaPz5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	nGu7y1iwgrNi6vKJbA2Ml9m7GDk5JARMJD5+/ccIYYtJXLi3ng3EFhKYzijRs8Adwu5nkjjc
	IAJiswmYSRxctBqol4NDREBWYma3XhcjFwezwAVGiZ9fJrCC1AgLOEls3P+PDaSGRUBVYmW/
	DIjJK+Ai0fNVCsSUEFCQmDPJZgIj9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwZHy
	THoH46oGi0OMAhyMSjy8E2Qjg4VYE8uKK3MPMUpwMCuJ8MqaRAUL8aYkVlalFuXHF5XmpBYf
	YkwGWj2RWUo0OR8YxXkl8YbGJuamxqaWJhYmZpakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwLi+MfHUHmelu9NPaft8UxVyMz2y4eTuY9envklsWd//8umHKF6nQyVbqk5+0Pla1VT0
	+1XBt2Oiy5kM/0/8XHCdSTn8Xux3W8VH/U8FztzNM2BxuemwTGVJtix7J09KnZZNKP/eBD69
	gsOTTnMs7b1qO4Mt5fF9t9dtlmt45FP2Khn9v2HHKKrEUpyRaKjFXFScCACUzBoq2AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes the 
1. bug causing a crash during module removal for exynos_adc.ko.
-> The bug was seen by Doug, while trying to compile the whole IIO subsystem
   as module @ https://lkml.org/lkml/2014/4/21/481 from Doug.

2. rearrange the clock and regulator enable/disable calls during
   probe, remove, suspend and resume calls
-> Comments give by Jonathan @ https://lkml.org/lkml/2014/4/23/644

3. reduces the timeout and uses wait_for_completion_timeout instead of the
   interruptible varient.
-> This change was under review @ https://lkml.org/lkml/2013/11/5/92
   Final comments were given by Tomasz, to split and submit.

Naveen Krishna Ch (2):
  iio: exynos_adc: use indio_dev->dev structure to handle child nodes
  iio: exynos_adc: rearrange clk and regulator enable/disable calls

Naveen Krishna Chatradhi (3):
  iio: exynos_adc: reduce timeout and use wait_for_completion_timeout
  iio: exynos_adc: do a soft reset in case of timeout
  iio: exynos_adc: do a reinit_completion before the conversion

 drivers/iio/adc/exynos_adc.c |  109 +++++++++++++++++++++++-------------------
 1 file changed, 61 insertions(+), 48 deletions(-)

-- 
1.7.9.5

