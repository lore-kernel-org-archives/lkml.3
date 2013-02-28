Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3B1KhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:37:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57031 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3B1KhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:37:19 -0500
X-AuditID: cbfee690-b7f6b6d000004563-f4-512f335eb2da
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/7] rtc: rtc-mv: add __init annotation
Date: Thu, 28 Feb 2013 19:37:18 +0900
Message-id: <000901ce159f$94e48270$bead8750$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vn5THVyS/kU1xRpiO8bTmT1G2Wg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zQ904Y/1Ag1O/ZSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuLzkFFPBd9aKxtmP2RsYf7F0MXJySAiYSFw7vosJwhaTuHBvPVsXIxeHkMAyRom/
	nQ+YYYrWr2hjhEhMZ5Tovb+YHcL5xShxffJasFFsAmoSX74cBkpwcIgI6Eu0tWiA1DAL9DJK
	nOndzQ5SIyxgLnG05wgrSA2LgKrErzPiIGFeAVuJLZt/skLYghI/Jt8DG8ksoCWxeVsTK4Qt
	L7F5zVtmkFYJAXWJR391ITbpSVy5mQlRISKx78U7RoiTj7FLNN+KBrFZBAQkvk0+xALRKSux
	6QDUV5ISB1fcYJnAKDYLyd5ZSPbOQrJ3FpINCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefn
	bmKERN2EHYz3DlgfYkwGWj+RWUo0OR8YtXkl8YbGxiZmJqYm5pam5qakCSuJ88pfkgkUEkhP
	LEnNTk0tSC2KLyrNSS0+xMjEwSnVwMjyI9HKe01NQYThFS0vQ+/FiucnmuQuet6akKb8Tucj
	p9MmU0HRc6Y8F+cvuPW3dVLv8UvCMgbKsqXXpLJEo2oPZz/eXL9/fY5L6uk7tlMuFmZanZ45
	fdtMYYlug9LZTCIndFL3POZMDpZ+Iihvdl78wqlbrCv6Uudn81Z9vaVsu/K8/J7ga0osxRmJ
	hlrMRcWJAGeHGV7QAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd04Y/1Ag5vzJCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLi85BRTwXfWisbZj9kbGH+xdDFyckgImEis
	X9HGCGGLSVy4t56ti5GLQ0hgOqNE7/3F7BDOL0aJ65PXgnWwCahJfPlyGCjBwSEioC/R1qIB
	UsMs0MsocaZ3NztIjbCAucTRniOsIDUsAqoSv86Ig4R5BWwltmz+yQphC0r8mHwPbCSzgJbE
	5m1NrBC2vMTmNW+ZQVolBNQlHv3VhdikJ3HlZiZEhYjEvhfvGCcwCsxCMmgWkkGzkAyahaRl
	ASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgqH4mvYNxVYPFIUYBDkYlHt4OE71AIdbE
	suLK3EOMEhzMSiK8Lvz6gUK8KYmVValF+fFFpTmpxYcYk4HenMgsJZqcD0w4eSXxhsYmZkaW
	RmYWRibm5qQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qBMaT155+uU2dfG76Ybr1kb8fc
	fM1lnHx8yhdvBCvrXdh3I/mayr7W92t23PNxnf1r+6xZPyLfBm5kefj97qbM4NyA7584Rayb
	HvPUa0SaKp9tv233PdpMa0X6+y130/eufGw1QfDGEomSKbvuvNkUIJfAGvJ9l81jxS3i/o0L
	Dlelis/6cO7QmQYlluKMREMt5qLiRADjxDXDLgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is used, bind/unbind via sysfs is
disabled. Thus, __init/__exit annotations can be added to
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index 57233c8..59d1671 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -215,7 +215,7 @@ static const struct rtc_class_ops mv_rtc_alarm_ops = {
 	.alarm_irq_enable = mv_rtc_alarm_irq_enable,
 };
 
-static int mv_rtc_probe(struct platform_device *pdev)
+static int __init mv_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct rtc_plat_data *pdata;
-- 
1.7.2.5


