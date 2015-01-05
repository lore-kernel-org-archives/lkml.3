Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbbAEBN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:13:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36762 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbbAEBN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:13:27 -0500
From: Tim Kryger <tim.kryger@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        Jonathan Richardson <jonathar@broadcom.com>
Cc: Tim Kryger <tim.kryger@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Linux PWM <linux-pwm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH 0/2] Allow registration of default inversed polarity PWMs
Date: Sun,  4 Jan 2015 17:12:54 -0800
Message-Id: <1420420376-13087-1-git-send-email-tim.kryger@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series alters the PWM core to allow the registration of controllers
that begin with inversed polarity output.  It also modifies the Broadcom
Kona driver to take advantage of this new call.

Arun Ramamurthy (1):
  drivers: pwm: bcm-kona: Dont set polarity in probe

Tim Kryger (1):
  drivers: pwm: core: Add pwmchip_add_inversed

 drivers/pwm/core.c         | 36 ++++++++++++++++++++++++++++--------
 drivers/pwm/pwm-bcm-kona.c |  9 +++------
 include/linux/pwm.h        |  6 ++++++
 3 files changed, 37 insertions(+), 14 deletions(-)

-- 
1.9.1

