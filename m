Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597Ab3GSOSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:18:33 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:38059 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106Ab3GSOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/13] ARM: ux500: Apply a ste-* prefix onto stuib.dtsi
Date: Fri, 19 Jul 2013 15:13:47 +0100
Message-Id: <1374243229-8585-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/{stuib.dtsi => ste-stuib.dtsi} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename arch/arm/boot/dts/{stuib.dtsi => ste-stuib.dtsi} (100%)

diff --git a/arch/arm/boot/dts/stuib.dtsi b/arch/arm/boot/dts/ste-stuib.dtsi
similarity index 100%
rename from arch/arm/boot/dts/stuib.dtsi
rename to arch/arm/boot/dts/ste-stuib.dtsi
-- 
1.8.1.2

