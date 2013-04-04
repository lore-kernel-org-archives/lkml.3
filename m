Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918Ab3DDQRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:17:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54232 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762887Ab3DDQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:17:30 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-62-515da798d7c9
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kgene.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 0/2] regulator: max8952: Add support for Device Tree
Date: Thu, 04 Apr 2013 18:17:18 +0200
Message-id: <1365092240-8956-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e+xgO7M5bGBBusuMln8m32KzeLA7Ies
	Fr0LrrJZnG16w25xedccNosZ5/cxWTRtn8BucbtxBZvF+hmvWRw4Pc7PWMjo8XLibzaPvi2r
	GD2O39jO5PF5k1wAaxSXTUpqTmZZapG+XQJXxp0v/SwFz9gqFt/YztbAuJm1i5GTQ0LAROLR
	/W42CFtM4sK99UA2F4eQwCJGif8vP7BCOF1MEvNX9jCDVLEJqEl8bngE1iEioCCxufcZWBGz
	wHtGiVu3+hhBEsICLhLnTz0AW8EioCqxavd+dhCbV8BR4l3nJHaIdfIST+/3sU1g5F7AyLCK
	UTS1ILmgOCk910ivODG3uDQvXS85P3cTIzh4nknvYFzVYHGIUYCDUYmHN6MvNlCINbGsuDL3
	EKMEB7OSCO/RFqAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYO
	TqkGxuCnb7P8Mgszr8SdFVfY+8NC47ZxfqizkKyfyp32vUX9xzfeSWtY+6C862ny+jMzj301
	YZu16UzSrcbkj64Pp3xLncH5lfNMTbeS0fk3BQqzSqa19e6VWB3zbu3mifenJeZe+zunPmf7
	8jadR5d1Vt2QFHIVNv24fZL42jwuXb0XuREbZLMi0pVYijMSDbWYi4oTAVtI2eoaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds Device Tree support to max8952 voltage regulator driver.
First patch prepares platform data structure to be generated at runtime
from data parsed from device tree. Second patch implements Device Tree
binding and adds necessary documentation.

Tested on Universal C210 board.

Tomasz Figa (2):
  regulator: max8952: Separate constraints from platform data struct
  regulator: max8952: Add Device Tree support

 .../devicetree/bindings/regulator/max8952.txt      | 52 +++++++++++++++
 arch/arm/mach-exynos/mach-universal_c210.c         | 27 ++++----
 drivers/regulator/max8952.c                        | 74 +++++++++++++++++++++-
 include/linux/regulator/max8952.h                  | 10 +--
 4 files changed, 143 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8952.txt

-- 
1.8.1.5

