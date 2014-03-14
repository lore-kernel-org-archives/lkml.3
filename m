Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaCNOTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:19:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48109 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755081AbaCNOTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:19:16 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, linux-pwm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/2] PWM: atmel: few fixes
Date: Fri, 14 Mar 2014 15:19:07 +0100
Message-Id: <1394806749-29778-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a few improvement for pwm-atmel. The first patch makes the driver
actually respect the polarity.

The second patch is solving an issue that I was trying to solve back in october.
When the channel was disabled, the output level got inversed. It actually was
that we had the polarity wrong from the beginning.

Alexandre Belloni (2):
  PWM: atmel-pwm: Fix polarity handling
  PWM: atmel: correct CDTY calculation

 drivers/pwm/pwm-atmel.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
1.8.3.2

