Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892AbaCSNKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:10:48 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50148 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804AbaCSNKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:10:41 -0400
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
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: Input: edt-ft5x06: Add DT support
Date: Wed, 19 Mar 2014 14:09:18 +0100
Message-Id: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
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

