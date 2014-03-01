Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaCAUW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 15:22:56 -0500
Received: from ring0.de ([5.45.105.125]:46933 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaCAUWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 15:22:54 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
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
Subject: [PATCHv2 0/2] Convert rx51-battery to IIO API and add DT support
Date: Sat,  1 Mar 2014 21:22:43 +0100
Message-Id: <1393705366-32420-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393375569-21751-1-git-send-email-sre@debian.org>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is PATCHv2 for converting rx51-battery to the IIO API
and adding DT support. The patchset compiles and has been
tested on my Nokia N900. It depends on another patchset
converting twl4030-madc to the IIO API [0].

Changes since PATCHv1 [1]:
 * Release IIO channels on device removal
 * Release IIO channels when errors occur in device probe

[0] https://lkml.org/lkml/2014/3/1/105
[1] Convert rx51-battery to IIO API and add DT support

-- Sebastian

Sebastian Reichel (2):
  rx51_battery: convert to iio consumer
  Documentation: DT: Document rx51-battery binding

 .../devicetree/bindings/power/rx51-battery.txt     | 25 ++++++
 drivers/power/rx51_battery.c                       | 90 ++++++++++++++++------
 2 files changed, 91 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/rx51-battery.txt

-- 
1.9.0

