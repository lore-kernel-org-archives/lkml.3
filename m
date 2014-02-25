Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaBYN2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:28:43 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:41103 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaBYN2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:28:42 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH 0/2] mfd: twl6040: Small clean-ups
Date: Tue, 25 Feb 2014 14:28:18 +0100
Message-Id: <1393334900-29740-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is two cleanups patches for the TWL6040 audio codec. The first
one checks for an error when reading the revision register (first read
in the probe path). The second removes a duplicate I2C writes.

Regards,
Florian

Florian Vaussard (2):
  mfd: twl6040: Check for error when reading revision register
  mfd: twl6040: Remove duplicate register write

 drivers/mfd/twl6040.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
1.8.1.2

