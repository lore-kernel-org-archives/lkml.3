Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161509Ab3DGDZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 23:25:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42272 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161347Ab3DGDZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 23:25:55 -0400
Date: Sun, 7 Apr 2013 11:23:04 +0800
From: Chen Baozi <baozich@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Romain Naour <romain.naour@openwide.fr>,
        linux-arch@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] gpio: remove GENERIC_GPIO completely
Message-ID: <20130407032304.GA11500@cbz-workstation>
References: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 06:11:15AM -0700, Alexandre Courbot wrote:
> Another issue, I could not update the Chinese documentation in a satisfying
> manner due to my absence of Chinese skills. Hope that will be forgiven.
> 
Hi Alexandre,

I have changed the Chinese documentation according to your update as
follows. Hopefully it would be helpful, :)

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
+选项。那些调用标准 GPIO 函数的驱动应该在 Kconfig
入口中声明依赖GENERIC_GPIO。
+当驱动包含文件:
 
        #include <linux/gpio.h>
  
