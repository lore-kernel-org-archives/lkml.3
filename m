Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaBZAq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:46:27 -0500
Received: from ring0.de ([5.45.105.125]:47355 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaBZAqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:46:24 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Jonathan Cameron <jic23@kernel.org>, Marek Belisko <marek@goldelico.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv1 0/2] Convert rx51-battery to IIO API and add DT support
Date: Wed, 26 Feb 2014 01:46:07 +0100
Message-Id: <1393375569-21751-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is PATCHv1 for converting rx51-battery to the IIO API
and adding DT support. The patchset compiles and has been
tested on my Nokia N900. It depends on another patchset
converting twl4030-madc to the IIO API:

https://lkml.org/lkml/2014/2/25/627

-- Sebastian

Sebastian Reichel (2):
  rx51_battery: convert to iio consumer
  Documentation: DT: Document rx51-battery binding

 .../devicetree/bindings/power/rx51-battery.txt     | 25 ++++++++
 drivers/power/rx51_battery.c                       | 68 ++++++++++++++--------
 2 files changed, 70 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/rx51-battery.txt

-- 
1.8.5.3

