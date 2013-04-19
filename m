Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390Ab3DSMwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:52:34 -0400
Received: from mail.neotion.com ([91.121.222.125]:55934 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968346Ab3DSMwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:52:33 -0400
Message-ID: <51713CA1.7020204@neotion.com>
Date: Fri, 19 Apr 2013 14:46:25 +0200
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org
CC: Chris Ball <cjb@laptop.org>, Namjae Jeon <linkinjeon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Add Documentation for MMC boot_enable attribute
X-Enigmail-Version: 1.5.1
OpenPGP: id=1166F485
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation on the enable_boot sysfs attribute.

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
---
 Documentation/mmc/mmc-dev-parts.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/mmc/mmc-dev-parts.txt
b/Documentation/mmc/mmc-dev-parts.txt
index f08d078..78228de 100644
--- a/Documentation/mmc/mmc-dev-parts.txt
+++ b/Documentation/mmc/mmc-dev-parts.txt
@@ -38,3 +38,9 @@ feature has been disabled on the card, the file will
be read-only.
 The boot partitions can also be locked permanently, but this feature is
 not accessible through sysfs in order to avoid accidental or malicious
 bricking.
+
+A special attribute named boot_enable is available to configure the
+selected partition for the eMMC 4.3+ boot operation mode.
+When selected between the two factory boot partitions and the main
+user partition, at boot time a special sequence enables makes the
+eMMC device to output the content of the selected partition.
-- 
1.7.0.4

