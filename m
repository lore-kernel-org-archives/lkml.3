Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbaDIH1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:27:49 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37599 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbaDIH1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:27:47 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: devicetree@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RESEND: PATCH 0/2] TC3589x keypad device tree support
Date: Wed,  9 Apr 2014 09:27:27 +0200
Message-Id: <1397028447-15347-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RESEND: can we merge this to the MFD+input trees now?

It seems no subsystem maintainers have any opinions and the DT
bindings people are silent on the matter since weeks.

Linus Walleij (2):
  mfd: tc3589x: Add device tree bindings
  input: tc3589x-keypad: support probing from device tree

 Documentation/devicetree/bindings/mfd/tc3589x.txt | 107 ++++++++++++++++++++++
 drivers/input/keyboard/tc3589x-keypad.c           |  66 ++++++++++++-
 2 files changed, 171 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tc3589x.txt

-- 
1.9.0

