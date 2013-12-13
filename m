Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3LMLOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:14:47 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33029 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751806Ab3LMLOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:14:46 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] pinctrl: pinconf: remove warning: unused variable 'ops'
Date: Fri, 13 Dec 2013 12:14:36 +0100
Message-Id: <1386933276-7158-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pinctrl/pinconf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 4187fe58794d..8bfa0643e5dc 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -296,7 +296,6 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
 static int pinconf_pins_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
-	const struct pinconf_ops *ops = pctldev->desc->confops;
 	unsigned i, pin;
 
 	seq_puts(s, "Pin config settings per pin\n");
@@ -343,7 +342,6 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
 	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	const struct pinconf_ops *ops = pctldev->desc->confops;
 	unsigned ngroups = pctlops->get_groups_count(pctldev);
 	unsigned selector = 0;
 
-- 
1.8.3.2

