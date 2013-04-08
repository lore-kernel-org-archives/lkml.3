Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623Ab3DHBZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:25:43 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:37296 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934511Ab3DHBZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:25:42 -0400
Date: Mon, 8 Apr 2013 09:22:53 +0800
From: Chen Baozi <baozich@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: update gpio Chinese documentation
Message-ID: <20130408012253.GA2545@cbz-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the GENERIC_GPIO has been removed and the documentation of it
has been modified, this patch updates the corresponding documentation of
gpio in Chinese.

Signed-off-by: Chen Baozi <baozich@gmail.com>
---
 Documentation/zh_CN/gpio.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/zh_CN/gpio.txt b/Documentation/zh_CN/gpio.txt
index 4fa7b4e..d5b8f01 100644
--- a/Documentation/zh_CN/gpio.txt
+++ b/Documentation/zh_CN/gpio.txt
@@ -84,10 +84,10 @@ GPIO 公约
 控制器的抽象函数来实现它。(有一些可选的代码能支持这种策略的实现,本文档
 后面会介绍，但作为 GPIO 接口的客户端驱动程序必须与它的实现无关。)
 
-也就是说,如果在他们的平台上支持这个公约，驱动应尽可能的使用它。平台
-必须在 Kconfig 中声明对 GENERIC_GPIO的支持 (布尔型 true)，并提供
-一个 <asm/gpio.h> 文件。那些调用标准 GPIO 函数的驱动应该在 Kconfig
-入口中声明依赖GENERIC_GPIO。当驱动包含文件:
+也就是说,如果在他们的平台上支持这个公约，驱动应尽可能的使用它。同时，平台
+必须在 Kconfig 中选择 ARCH_REQUIRE_GPIOLIB 或者 ARCH_WANT_OPTIONAL_GPIOLIB
+选项。那些调用标准 GPIO 函数的驱动应该在 Kconfig 入口中声明依赖GENERIC_GPIO。
+当驱动包含文件:
 
 	#include <linux/gpio.h>
 
-- 
1.8.1.4

