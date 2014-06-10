Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFJOnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:43:06 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:40158 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751909AbaFJOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:43:02 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk, heiko@sntech.de, rob.jones@codethink.co.uk
Subject: [PATCH 0/3] use managed resources for gpio-regulator probe
Date: Tue, 10 Jun 2014 15:41:45 +0100
Message-Id: <1402411308-14182-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change gpio-reulator-probe() to use managed resources.

Add new managed resource functions as needed to achieve this.

Amend the following functions:

devm_kstrdup()
gpio_regulator_probe()

Add the following functions:

devm_kmemdup()
devm_gpio_request_array()
devm_gpio_free_array()

Remove the following functions:

gpio_regulator_remove()

