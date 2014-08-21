Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaHUSTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:19:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45498 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaHUST3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:19:29 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: input: drv2667: add support for drv2667 haptic driver
Date: Thu, 21 Aug 2014 13:19:01 -0500
Message-ID: <1408645143-25690-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for the TI DRV2667 haptic driver.
This device driver a linear resonant actuator (LRA)
based on user space requests to provide either a
vibration or a haptic tactile response to an input.

This device has the ability to store wave patterns in RAM
and these patterns can be executed based on user input.

For this initial series I added just the basic vibration
pattern along that will continuously execute until
the user indicates to stop.

[PATCH 1/2] doc: dt/bindings: input: introduce TI DRV2667 haptic
[PATCH 2/2] input: misc: Add support for the DRV2667 haptic driver
