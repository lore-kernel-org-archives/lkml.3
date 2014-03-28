Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaC1SCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:02:51 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:42146 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaC1R7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:59:37 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 06/10] irqchip: atmel-aic: move binding doc to interrupt-controller directory
Date: Fri, 28 Mar 2014 18:59:04 +0100
Message-Id: <1396029548-10928-7-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move atmel aic driver doc to the interrupt-controller directory as the new
driver now lays in drivers/irqchip/atmel-aic.c.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 .../atmel,aic.txt}                                 |    0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/{arm/atmel-aic.txt => interrupt-controller/atmel,aic.txt} (100%)

diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
similarity index 100%
rename from Documentation/devicetree/bindings/arm/atmel-aic.txt
rename to Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
-- 
1.7.9.5

