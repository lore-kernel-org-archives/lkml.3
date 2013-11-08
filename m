Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab3KHWMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:12:06 -0500
Received: from ring0.de ([91.143.88.219]:60236 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab3KHWL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:11:56 -0500
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
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv7 0/4] twl4030-pwrbutton DT binding
Date: Fri,  8 Nov 2013 23:11:23 +0100
Message-Id: <1383948687-32279-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the seventh iteration of DT support for the TWL4030
power button.

Changes since v6 [0]:
* Splitted DT binding documentation into its own patch
* Updated commit message of first patch
* Added Reviewed-by: Aaro Koskinen
* Added Tested-by: Florian Vaussard
* Added Acked-by: Kumar Gala

[0] https://lkml.org/lkml/2013/10/24/269

-- Sebastian

Sebastian Reichel (4):
  Input: twl4030-pwrbutton: add device tree support
  dt: binding documentation for twl4030-pwrbutton
  Input: twl4030-pwrbutton: use dev_err for errors
  Input: twl4030-pwrbutton: simplify driver using devm_*

 .../bindings/input/twl4030-pwrbutton.txt           | 21 +++++++++++
 drivers/input/misc/twl4030-pwrbutton.c             | 44 +++++++++-------------
 2 files changed, 38 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt

-- 
1.8.4.rc3

