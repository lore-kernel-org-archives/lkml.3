Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbaD2IYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:24:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58730 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaD2IYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:24:43 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-a7-535f61ca92bf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 0/4] clocksource: remove unnecessary OOM messages
Date: Tue, 29 Apr 2014 17:24:41 +0900
Message-id: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9jhHgACh38PpSJS1ewNnY0fIuPzw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zY91TifHBBr8uc1jM+yxrcXnhJVaL
	y7vmsFls3jSV2YHF4861PWwe786dY/fo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujFkX3zAX
	zGWtOPh3IksD42SWLkZODgkBE4lPUyezQdhiEhfurQeyuTiEBJYxSlw73MAMU3T4+0qoxHRG
	ifV/r7NAOL8ZJeaf3gA2ik1ATeLLl8PsILaIgIHE69O/wWxmgTyJG9uPA9kcHMICjhLrrySD
	hFkEVCW2PXjKDBLmFbCVmDpbFSTMKyAo8WPyPRaITi2J9TuPM0HY8hKb17wFK5cQUJd49FcX
	xBQR0JO4OjUNokJEYt+Ld4wgh0kIbGKXWNbRwASxSUDi2+RDLBCtshKbDkB9JSlxcMUNlgmM
	YrOQLJ6FZPEsJItnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIfPXuYLx9wPoQ
	YzLQ+onMUqLJ+cD4zCuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGxuWds/W/9R/blNxzIzBYuuPd1fs3X6za3Djp2dfgassDG4P/3r+6gjFLRjvH
	ZNmx8CnmwoLCneE3LqYlP5tU+Oeax45VqQ8WzPjhwX18x1aPDwU+E4WW1VWv4bjTu3ZhTdrD
	PjHJpSrvPl/Z0LqH58q1RYaaS6Ztr3x3jbHMLt6TN/C+yDzbc7OVWIozEg21mIuKEwGV/8dB
	xQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoO6pxPhgg5dLWS3mfZa1uLzwEqvF
	5V1z2Cw2b5rK7MDicefaHjaPd+fOsXv0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8asi2+YC+ayVhz8O5GlgXEySxcjJ4eEgInE4e8r2SBsMYkL99YD
	2VwcQgLTGSXW/73OAuH8ZpSYf3oDWAebgJrEly+H2UFsEQEDidenf4PZzAJ5Eje2HweyOTiE
	BRwl1l9JBgmzCKhKbHvwlBkkzCtgKzF1tipImFdAUOLH5HssEJ1aEut3HmeCsOUlNq95C1Yu
	IaAu8eivLogpIqAncXVqGkSFiMS+F+8YJzAKzEIyaBaSQbOQDJqFpGUBI8sqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjODofSa1g3Flg8UhRgEORiUeXoOouGAh1sSy4srcQ4wSHMxKIrz5
	VvHBQrwpiZVVqUX58UWlOanFhxiTgd6cyCwlmpwPTCx5JfGGxiZmRpZGZhZGJubmpAkrifMe
	aLUOFBJITyxJzU5NLUgtgtnCxMEp1cCY3Dln4/MjOgwt5hNz2z9+uZzBpZ779six2RnzDPoF
	furmu948q/thKkflCY/ws3d2HFoWMTfG1kB470HWc847ue+tvqCkNf/mInmmf/tq1JnWif43
	uXj/tf71O/Nkl7u+s42/lvIgcuuHqN+iug9XbRRtXia5WtA5tv7tFKb5TX9nsIUrhh2uUWIp
	zkg01GIuKk4EAK/VbvQiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message. For example,
k.alloc and v.alloc failures use dump_stack().

Jingoo Han (4):
      clocksource: em_sti: remove unnecessary OOM messages
      clocksource: sh_cmt: remove unnecessary OOM messages
      clocksource: sh_mtu2: remove unnecessary OOM messages
      clocksource: sh_tmu: remove unnecessary OOM messages

---
 drivers/clocksource/em_sti.c  |    4 +---
 drivers/clocksource/sh_cmt.c  |    4 +---
 drivers/clocksource/sh_mtu2.c |    4 +---
 drivers/clocksource/sh_tmu.c  |    4 +---
 4 files changed, 4 insertions(+), 12 deletions(-)

