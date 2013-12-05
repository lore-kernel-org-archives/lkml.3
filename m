Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3LEXJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:09:47 -0500
Received: from ring0.de ([91.143.88.219]:39506 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3LEXJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:09:44 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH 0/2] tsc2005 DT binding
Date: Fri,  6 Dec 2013 00:09:37 +0100
Message-Id: <1386284979-9680-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This adds device tree support for the tsc2005 touchscreen
controller, which is currently only used by the Nokia N900
board.

The patch does not update the reset pin handling for platform
data based probe to avoid merge conflicts (Tony will remove
the Nokia N900 boardcode in 3.14). The platform data based
probe can be removed once the N900 boardcode is gone.

-- Sebastian

Sebastian Reichel (2):
  Input: tsc2005: add DT support
  Documentation: dt: Document TSC2005 DT binding

 .../bindings/input/touchscreen/tsc2005.txt         | 49 +++++++++++
 drivers/input/touchscreen/tsc2005.c                | 95 ++++++++++++++++++----
 2 files changed, 127 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/tsc2005.txt

-- 
1.8.4.3

