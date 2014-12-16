Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaLPWBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:01:39 -0500
Received: from marmot.wormnet.eu ([188.246.204.87]:35169 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaLPWBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:01:34 -0500
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH 0/2] HID: lenovo: Extra features for compact keyboards
Date: Tue, 16 Dec 2014 21:26:44 +0000
Message-Id: <1418765206-30885-1-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another set of patches for the Lenovo Compact Keyboards, enabling
sensitivity control and improving scroll-wheel emulation.

This applies to 3.18, once previous fixups[0] have been applied. Tested
with USB and Bluetooth versions of the keyboard.

Cheers,

[0] https://lkml.org/lkml/2014/11/9/25

Jamie Lentin (2):
  HID: lenovo: Add sensitivity control to compact keyboards
  HID: lenovo: Use native middle-button mode for compact keyboards

 drivers/hid/hid-lenovo.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

-- 
2.1.3

