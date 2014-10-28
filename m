Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaJ1VAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:00:08 -0400
Received: from down.free-electrons.com ([37.187.137.238]:36591 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752436AbaJ1VAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:00:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 1/2] Documentation: dmaengine: Move the current doc to a folder of its own
Date: Tue, 28 Oct 2014 21:55:49 +0100
Message-Id: <1414529750-14431-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414529750-14431-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1414529750-14431-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the current client-side documentation to a subfolder to prepare the
introduction of a provider-side API documentation.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/{dmaengine.txt => dmaengine/client.txt} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{dmaengine.txt => dmaengine/client.txt} (100%)

diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine/client.txt
similarity index 100%
rename from Documentation/dmaengine.txt
rename to Documentation/dmaengine/client.txt
-- 
2.1.1

