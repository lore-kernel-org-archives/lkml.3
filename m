Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaAPITL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:19:11 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:58546 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaAPITJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:19:09 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/2] ARM: dts: imx53: add support for Ka-Ro TX53 modules
Date: Thu, 16 Jan 2014 09:15:21 +0100
Message-Id: <1389860123-14874-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Ka-Ro electronics GmbH TX53 modules.
There are two distinct module types. One with an LVDS display
interface and SATA support, the other with a parallel LCD
interface and no SATA interface.

Changes wrt. v1:
- set the '#pwm-cells' property locally due to the changed
  pwm-polarity patch that made this property optional.
  see <1389859585-14006-3-git-send-email-LW@KARO-electronics.de>

