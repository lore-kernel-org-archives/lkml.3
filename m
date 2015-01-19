Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbbASXYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 18:24:06 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57099 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbASXYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 18:24:01 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Carlo Caione <carlo@caione.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 1/3] of: Add vendor prefix for MINIX
Date: Tue, 20 Jan 2015 00:22:57 +0100
Message-Id: <1421709779-25691-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421709779-25691-1-git-send-email-b.galvani@gmail.com>
References: <1421709779-25691-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MINIX Technology Limited to the list of device tree vendor
prefixes. The company manufactures digital media players and mini-ITX
motherboards.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index b1df0ad..09b01de 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -100,6 +100,7 @@ merrii	Merrii Technology Co., Ltd.
 micrel	Micrel Inc.
 microchip	Microchip Technology Inc.
 micron	Micron Technology Inc.
+minix	MINIX Technology Ltd.
 mitsubishi	Mitsubishi Electric Corporation
 mosaixtech	Mosaix Technologies, Inc.
 moxa	Moxa
-- 
2.1.4

