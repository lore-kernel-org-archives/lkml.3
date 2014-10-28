Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaJ1VAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:00:48 -0400
Received: from down.free-electrons.com ([37.187.137.238]:36600 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754660AbaJ1VAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:00:06 -0400
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
Subject: [PATCH v3 0/2] dmaengine: Add driver documentation
Date: Tue, 28 Oct 2014 21:55:48 +0100
Message-Id: <1414529750-14431-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the third attempt at documenting how to write a dmaengine
driver.

Changes from v2:
  - English corrections from Randy Dunlap
  - Reworked the burst explanations
  - Reworked the interleaved transfers explanations

Maxime Ripard (2):
  Documentation: dmaengine: Move the current doc to a folder of its own
  Documentation: dmaengine: Add a documentation for the dma controller
    API

 .../{dmaengine.txt => dmaengine/client.txt}        |   0
 Documentation/dmaengine/provider.txt               | 366 +++++++++++++++++++++
 2 files changed, 366 insertions(+)
 rename Documentation/{dmaengine.txt => dmaengine/client.txt} (100%)
 create mode 100644 Documentation/dmaengine/provider.txt

-- 
2.1.1

