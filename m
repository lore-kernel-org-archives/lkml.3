Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732Ab3GSOTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:19:51 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:39215 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3GSOOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/13] ARM: ux500: Apply a ste-* prefix onto snowball.dts
Date: Fri, 19 Jul 2013 15:13:41 +0100
Message-Id: <1374243229-8585-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/{snowball.dts => ste-snowball.dts} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename arch/arm/boot/dts/{snowball.dts => ste-snowball.dts} (100%)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
similarity index 100%
rename from arch/arm/boot/dts/snowball.dts
rename to arch/arm/boot/dts/ste-snowball.dts
-- 
1.8.1.2

