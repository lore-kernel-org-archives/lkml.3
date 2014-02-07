Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaBGIAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:00:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34486 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaBGIAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:00:12 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-d5-52f4928b99b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 00/10] rtc: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:00:11 +0900
Message-id: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zI93uSV+CDD5cMLJYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY9qldSwFjzkrbjf8Zm5g3MHexcjJISFgIjHj42QoW0ziwr31bF2MXBxCAssYJZ7e
	7WKBKfoz6xsziC0ksIhR4tJKNYiiX4wSDZufs4Ik2ATUJL58OQw0iYNDREBfoq1FA6SGWaCX
	UeJM726wDcIC1hIPZ54Hs1kEVCXun93IBmLzCthKXNs8nxHCFpT4Mfke2GJmAS2J9TuPM0HY
	8hKb17xlBpkvIaAu8eivLkhYREBPYs+8ZVDlIhL7XrxjBNkrIXCMXeLHjnZmiF0CEt8mH2KB
	6JWV2HSAGeIvSYmDK26wTGAUm4Vk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz
	0vWS83M3MUIib+IOxvsHrA8xJgOtn8gsJZqcD4zcvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8l
	BQkJpCeWpGanphakFsUXleakFh9iZOLglGpgFPllt+fodY8/TEWsKYwFe97lTdzN/7FaSfye
	P/ds7XtTDmw0ZLdbK6t0//zpEtX+kNnq+5oXrNLjdzHrDEg1qvlzapvbTrGrGZsfpwnL19br
	td2ctsi7bUWAxncjxxtRwtOyI5nS/qk1ZTdt2B500PStQPaKfSIWLKYTmEwqE9U75BM9cq4o
	sRRnJBpqMRcVJwIA7xThc9ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd3uSV+CDLqX6lksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHt0jqWgsecFbcbfjM3MO5g72Lk5JAQMJH4
	M+sbM4QtJnHh3no2EFtIYBGjxKWVal2MXED2L0aJhs3PWUESbAJqEl++HAZq5uAQEdCXaGvR
	AKlhFuhllDjTuxtsqLCAtcTDmefBbBYBVYn7ZzeCDeUVsJW4tnk+I4QtKPFj8j0WEJtZQEti
	/c7jTBC2vMTmNW+ZQeZLCKhLPPqrCxIWEdCT2DNvGVS5iMS+F+8YJzAKzEIyaRaSSbOQTJqF
	pGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOC4fia1g3Flg8UhRgEORiUe3hNLPwcJ
	sSaWFVfmHmKU4GBWEuH92fAlSIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgSknryTe0NjE
	zMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoY47a+PXTz7ukL67/GbxYK
	09Mr4qxTnjZLIn5K2JFJKzJ2XI1glyxhYOSrWqzCWeiuuWHnR56UoL9zQh11fxxhEGB5EjX5
	3GQ717nNv86Lbm5oyd+v/FB7tmNZHtf5hJf/dsif5QmceWkd13qfm5XXlobfmGd3cINcU1vo
	pdt3nJZ+zb3GyV5bpsRSnJFoqMVcVJwIAIcQ28IvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message. For example,
k.alloc and v.alloc failures use dump_stack().

Jingoo Han (10):
      rtc: rtc-at32ap700x: Remove unnecessary OOM messages
      rtc: rtc-davinci: Remove unnecessary OOM messages
      rtc: rtc-ds1390: Remove unnecessary OOM messages
      rtc: rtc-lpc32xx: Remove unnecessary OOM messages
      rtc: rtc-moxart: Remove unnecessary OOM messages
      rtc: rtc-nuc900: Remove unnecessary OOM messages
      rtc: rtc-pm8xxx: Remove unnecessary OOM messages
      rtc: rtc-rx8025: Remove unnecessary OOM messages
      rtc: rtc-sirfsoc: Remove unnecessary OOM messages
      rtc: rtc-spear: Remove unnecessary OOM messages
---
 drivers/rtc/rtc-at32ap700x.c |    4 +---
 drivers/rtc/rtc-davinci.c    |    4 +---
 drivers/rtc/rtc-ds1390.c     |    5 ++---
 drivers/rtc/rtc-lpc32xx.c    |    5 ++---
 drivers/rtc/rtc-moxart.c     |    4 +---
 drivers/rtc/rtc-nuc900.c     |    5 ++---
 drivers/rtc/rtc-pm8xxx.c     |    4 +---
 drivers/rtc/rtc-rx8025.c     |    1 -
 drivers/rtc/rtc-sirfsoc.c    |    6 +-----
 drivers/rtc/rtc-spear.c      |    4 +---
 10 files changed, 12 insertions(+), 30 deletions(-)

