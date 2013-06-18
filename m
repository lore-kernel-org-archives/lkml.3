Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab3FRQTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:19:25 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41883 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab3FRQTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:19:21 -0400
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 21:49:19 +0530
Message-ID: <CA+G9fYu3_-RZxFyRENuqJvzsM=YToT7PG+5fUytMzhsFu3=z7g@mail.gmail.com>
Subject: linux-next: origen build failed at drivers/pinctrl/pinctrl-exynos.c
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Doug Anderson <dianders@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

linux-next branch failed to build origen build

defconfig: exynos_defconfig

full build log:
----------------
https://ci.linaro.org/jenkins/job/linux-next/hwpack=origen,label=kernel_cloud/72/console

build error log:
--------------------
05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:
In function ‘exynos_wkup_irq_mask’:
05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:299:3:
error: implicit declaration of function ‘exynos_wkup_irq_ack’
[-Werror=implicit-function-declaration]
05:02:12    exynos_wkup_irq_ack(irqd);
05:02:12    ^
05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:
At top level:
05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:310:13:
warning: conflicting types for ‘exynos_wkup_irq_ack’ [enabled by
default]
05:02:12  static void exynos_wkup_irq_ack(struct irq_data *irqd)
05:02:12              ^
05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:310:13:
error: static declaration of ‘exynos_wkup_irq_ack’ follows non-static
declaration
05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:299:3:
note: previous implicit declaration of ‘exynos_wkup_irq_ack’ was here
05:02:12    exynos_wkup_irq_ack(irqd);
05:02:12    ^
05:02:12 cc1: some warnings being treated as errors
05:02:12 make[3]: *** [drivers/pinctrl/pinctrl-exynos.o] Error 1
05:02:12 make[2]: *** [drivers/pinctrl] Error 2

Best regards
Naresh kamboju
