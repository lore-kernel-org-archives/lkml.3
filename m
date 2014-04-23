Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbaDWVQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:16:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49469 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070AbaDWVQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:16:42 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Barry Song <Baohua.Song@csr.com>,
        Barry Song <baohua@kernel.org>
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/2] RTF: pinctrl: sirf: state container refactorings
Date: Wed, 23 Apr 2014 23:16:30 +0200
Message-Id: <1398287792-19831-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a refactoring attempt that may not work as I can't test it
(it compiles), but you sure can see what I want to happen in the SIRF
driver.

By registering the GPIO range from the gpiochip side we can get rid
of the static globals and be a nice kernel citizen. See further
Documentation/driver-model/design-patterns.txt.

Linus Walleij (2):
  RFT: pinctrl: sirf: switch to using allocated state container
  RFT: pinctrl: sirf: move sgpio lock into state container

 drivers/pinctrl/sirf/pinctrl-sirf.c | 240 ++++++++++++++++++++----------------
 1 file changed, 134 insertions(+), 106 deletions(-)

-- 
1.9.0

