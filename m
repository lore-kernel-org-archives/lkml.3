Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaHKJUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:20:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31203 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHKJUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:20:43 -0400
X-AuditID: cbfee690-b7f526d000003627-c7-53e88ae75b53
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] extcon: sm5502: Clean up coding style
Date: Mon, 11 Aug 2014 18:20:35 +0900
Message-id: <1407748837-15153-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWyRsSkWPd514tgg6szlSyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6MppPXWQo+sVT83b6MtYGx
	l6WLkZNDQsBE4sr+i4wQtpjEhXvr2boYuTiEBJYySjT9XMQOU7R0+15WiMQiRomu9hlQVU1M
	Ejt+HGICqWIT0JLY/+IGG4gtIqAgsbn3GSuIzSwQL3G2uxtoBQeHsICVxLnVuiBhFgFVicsT
	5oCV8wq4Sly5+oQZYpmcxIc9j9hB5ksIXGaTWPjiAjNEg4DEt8mHWEDmSAjISmw6AFUvKXFw
	xQ2WCYyCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIEht7pf88m7GC8d8D6EGMy0LiJ
	zFKiyfnA0M0riTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsYQ2YsL56XLLDu5R0nZ4MHSd9UVCx+ky3xuSnqu//fLh18WjaVT63bxTpG9oWv1f1pd
	bHnZhP9zf2xd1XWt7veErk3JO3b19nN26pZ+TPU2701mPqW1kznIb4+Ka0ht2s6JQi6bDXQv
	b/Up/+xYkzztVAfrtYM8G1IVTW8tiJh0e9uBBXbrHv9QYinOSDTUYi4qTgQASwOg8FMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAd3nXS+CDbqfSVtc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGU0nr7MUfGKp+Lt9GWsDYy9LFyMnh4SAicTS7XtZIWwxiQv31rN1MXJxCAksYpTo
	ap8B5TQxSez4cYgJpIpNQEti/4sbbCC2iICCxObeZ2DdzALxEme7uxm7GDk4hAWsJM6t1gUJ
	swioSlyeMAesnFfAVeLK1SfMEMvkJD7secQ+gZF7ASPDKkbR1ILkguKk9FwjveLE3OLSvHS9
	5PzcTYzgwH4mvYNxVYPFIUYBDkYlHt6DX54HC7EmlhVX5h5ilOBgVhLh/WnxIliINyWxsiq1
	KD++qDQntfgQoynQ9onMUqLJ+cCoyyuJNzQ2MTOyNDI3tDAyNlcS5z3Yah0oJJCeWJKanZpa
	kFoE08fEwSnVwJgm2jLV0pCbM5wzg1WUu8bC5KXtfE6xK81795evvxki+tNO67VASaqU4I3O
	m0/uvNuQsVdpw3qFFeb3Jgm0tbu++Xl4oT7XZTvmg2YbXdL6a3KXJrj8tl7dIy0brGH47+eN
	TcnuvTM2BJ31vFpdp3dOY7HF7U3bOIOibu7YeEtafm6885P8JUosxRmJhlrMRcWJAOh8+k2C	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clean up coding style for extcon-sm5502 driver and fix wrong mask
operation to get cable_type value.

Chanwoo Choi (2):
  extcon: sm5502: Move sm5502.h header file to extcon directory
  extcon: sm5502: Fix bug to check cable type

 drivers/extcon/extcon-sm5502.c |  14 +-
 drivers/extcon/extcon-sm5502.h | 282 ++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/sm5502.h  | 287 -----------------------------------------
 3 files changed, 287 insertions(+), 296 deletions(-)
 create mode 100644 drivers/extcon/extcon-sm5502.h
 delete mode 100644 include/linux/extcon/sm5502.h

-- 
1.8.0

