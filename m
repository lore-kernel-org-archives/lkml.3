Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab3JWRyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:54:25 -0400
Received: from ring0.de ([91.143.88.219]:42698 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab3JWRyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:54:23 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sebastian Reichel <sre@debian.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCHv4 0/3] DT Support for TWL4030 power button
Date: Wed, 23 Oct 2013 19:54:09 +0200
Message-Id: <1382550852-11508-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the fourth iteration of DT support for the TWL4030
power button.

Changes since v3 [0]:
* remove twl4030_pwrbutton_remove function, which is no
  longer needed after devm_ conversion.

[0] https://lkml.org/lkml/2013/10/23/353

-- Sebastian

Sebastian Reichel (3):
  Input: twl4030-pwrbutton - add device tree support
  Input: twl4030-pwrbutton: use dev_err for errors
  Input: twl4030-pwrbutton: simplify driver using devm_*

 .../bindings/input/twl4030-pwrbutton.txt           | 13 ++++++
 drivers/input/misc/twl4030-pwrbutton.c             | 46 +++++++++-------------
 2 files changed, 31 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt

-- 
1.8.4.rc3

