Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab3GSOOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:14:11 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60420 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106Ab3GSOOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/13] ARM: ux500: Apply a ste-* prefix onto href.dtsi
Date: Fri, 19 Jul 2013 15:13:44 +0100
Message-Id: <1374243229-8585-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/{href.dtsi => ste-href.dtsi} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename arch/arm/boot/dts/{href.dtsi => ste-href.dtsi} (100%)

diff --git a/arch/arm/boot/dts/href.dtsi b/arch/arm/boot/dts/ste-href.dtsi
similarity index 100%
rename from arch/arm/boot/dts/href.dtsi
rename to arch/arm/boot/dts/ste-href.dtsi
-- 
1.8.1.2

