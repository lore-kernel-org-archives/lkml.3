Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab3GSOOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:14:19 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33781 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab3GSOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/13] ARM: ux500: Apply a ste-* prefix onto dbx5x0.dtsi
Date: Fri, 19 Jul 2013 15:13:48 +0100
Message-Id: <1374243229-8585-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/{dbx5x0.dtsi => ste-dbx5x0.dtsi} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename arch/arm/boot/dts/{dbx5x0.dtsi => ste-dbx5x0.dtsi} (100%)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/ste-dbx5x0.dtsi
similarity index 100%
rename from arch/arm/boot/dts/dbx5x0.dtsi
rename to arch/arm/boot/dts/ste-dbx5x0.dtsi
-- 
1.8.1.2

