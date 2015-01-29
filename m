Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbbA2Ipo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:45:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8882 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbbA2Ipn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:45:43 -0500
X-AuditID: cbfee691-f79b86d000004a5a-0b-54c9f3350546
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 0/2] extcon: max77693: Fix cable name of MHL-TA and USB-HOST
Date: Thu, 29 Jan 2015 17:45:22 +0900
Message-id: <1422521124-508-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsWyRsSkQNf088kQg3OvlC2uf3nOajHp/gQW
	ix0NR1gtLu+aw+bA4tG3ZRWjx+dNcgFMUVw2Kak5mWWpRfp2CVwZM6ZPZyn4ylSxbI14A+Nq
	pi5GTg4JAROJiQca2SBsMYkL99YD2VwcQgJLGSVWXtzICFPUvPsCI0RiOqPE6QlXWCGcNiaJ
	Ga0vWECq2AS0Jb6vX8wKYosIuEl8+/SHGcRmFvCS2HF5LdgkYQEfiWvzZ4DVsAioSnTs7gLr
	5QWq//D7BVCcA2ibgsScSTYg8yUELrNJ3Ny5ghmiXkDi2+RDLBA1shKbDjBDHCcpcXDFDZYJ
	jIILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgQG3ul/zybuYLx/wPoQowAHoxIPb0Lj
	yRAh1sSy4srcQ4ymQBsmMkuJJucDwzuvJN7Q2MzIwtTE1NjI3NJMSZxXR/pnsJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQbGYz+nWSu0XX/LVaTBW5yvYq1n7LhgfT974OFbq1477gkVvXWx
	XviMssErVSVjL82P67N5Kx7e2ZDA/uzIMv1Zv2L+Cr2fuj7esmH1p/59hzX5SiebL86cbHP8
	XuSkbxFnJxe0s4T/ND3DWf3H1XZi09mFL8XnPa68dcR1tVX+w1uyB7vrCn9fVGIpzkg01GIu
	Kk4EAIVDZlw3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQV3TzydDDK49kbW4/uU5q8Wk+xNY
	LHY0HGG1uLxrDpsDi0ffllWMHp83yQUwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYwZsyYPp2l4CtTxbI14g2Mq5m6GDk5JARMJJp3X2CEsMUkLtxbz9bFyMUhJDCdUeL0
	hCusEE4bk8SM1hcsIFVsAtoS39cvZgWxRQTcJL59+sMMYjMLeEnsuLwWbJKwgI/EtfkzwGpY
	BFQlOnZ3gfXyAtV/+P0CKM4BtE1BYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBIf1M+kdjKsaLA4xCnAwKvHwJjSeDBFiTSwrrsw9xCjBwawkwiv+BijEm5JYWZValB9f
	VJqTWnyI0RRo+URmKdHkfGDM5ZXEGxqbmBlZGpkbWhgZmyuJ8yrZt4UICaQnlqRmp6YWpBbB
	9DFxcEo1MDYu9NPJPxQ/127zzTqlj7Nyj73tkf904vA5Yf8piy78XNVos+KjtPtl+zlLN+n9
	mjSrOP7lDumJNSI7V02fuVZImvHJtbi1m3c7M1341fvl01btBImCFbn+dZPiuQUeh5XNC/x8
	dcV7vWyPObbHfgT9ST707oDYtet2IpolgqHpX0/kCXJxPV+nxFKckWioxVxUnAgAcAKXWoEC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes extcon cable name of MHL-TA
and unify the term 'USB-HOST' and 'USB-OTG' to 'USB-HOST'.

Jaewon Kim (2):
  extcon: max77693: Fix cable name of MHL-TA
  extcon: max77693: Fix cable name of USB-HOST

 drivers/extcon/extcon-max77693.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

-- 
1.7.9.5

