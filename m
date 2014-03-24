Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaCXPLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:11:50 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:53342 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaCXPLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:11:46 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Fugang Duan <B38611@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Budig <simon.budig@kernelconcepts.de>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Daniel Wagener <daniel.wagener@kernelconcepts.de>
Subject: [PATCHv6 0/5] Input: edt-ft5x06: Add DT support
Date: Mon, 24 Mar 2014 16:11:05 +0100
Message-Id: <1395673870-29435-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395323075-12146-1-git-send-email-LW@KARO-electronics.de>
References: <1395323075-12146-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes wrt. v1:
addressed the comments from Jingoo Han and Mark Rutland
- added another patch to convert the driver to use devm_* functions
- removed sysfs reference from bindings documentation
- changed '_' to '-' in property name
- added 'edt,' prefix to properties names
- added sanity check for parameters read from DT
- cleaned up the gpio handling code

Changes wrt. v2:
- fixed the devm_* messup reported by Dmitry Torokhov
- added unit for report-rate property to the binding doc
- added separate patch to fix the reset delays

Changes wrt: v3:
- removed patches that have already been applied in the mean time
- ignore touchdown events, since those may report bad coordinates
- added support for a new firmware version

Changes wrt: v4:
- removed some empty lines in the cleanup patch
- addressed comments by Mark Rutland concerning the binding doc
- use of_property_read_u32() instead of of_property_get()
- dropped the 'report_rate' property
- addressed comments by Fugang Duan
- added Daniel Wagener and myself to the Copyright header in the
  source file
- use msleep() rather than mdelay() for the reset/wake pin timing

Changes wrt: v5:
- added missing '&' to parameter of of_property_read_u32()

