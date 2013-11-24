Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3KXQto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:49:44 -0500
Received: from ring0.de ([91.143.88.219]:60779 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab3KXQtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:49:42 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCH 0/3] DT support for bq2415x
Date: Sun, 24 Nov 2013 17:49:28 +0100
Message-Id: <1385311771-447-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds DT support for the bq2415x charger, which is used in the
Nokia N900. The changes depend on Pali Rohár's "[PATCH v2 0/3] Add support for
charging battery in Nokia RX-51" patchset [0].

[0] https://lkml.org/lkml/2013/11/19/106

-- Sebastian

Sebastian Reichel (3):
  power_supply: add power_supply_get_by_phandle
  bq2415x_charger: add DT support
  dt: binding documentation for bq2415x charger

 .../devicetree/bindings/power/bq2415x.txt          | 43 +++++++++++++
 drivers/power/bq2415x_charger.c                    | 72 ++++++++++++++++------
 drivers/power/power_supply_core.c                  | 24 ++++++++
 include/linux/power_supply.h                       |  2 +
 4 files changed, 121 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/bq2415x.txt

-- 
1.8.4.3

