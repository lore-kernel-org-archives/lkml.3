Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935947Ab3DKCNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:13:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61196 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762074Ab3DKCNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:13:24 -0400
Message-ID: <1365646391.3832.2.camel@phoenix>
Subject: regulator: Some patches for twl-regulator are not found in
 regulator tree
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 10:13:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
I found some patches for twl are not in linux-next, and I cannot find them
in your tree ( although you replied the patches applied. )

I think below patches are missing:
[PATCH] regulator: twl: Remove TWL6030_FIXED_RESOURCE [1]
[PATCH] regulator: twl: Remove VDD1_VSEL_table and VDD2_VSEL_table [2]
[PATCH] regulator: twl: Convert fixed voltage to use regulator_list_voltage_linear [3]

[1] https://lkml.org/lkml/2013/2/15/691
[2] https://lkml.org/lkml/2013/2/15/272
[3] https://lkml.org/lkml/2013/2/15/681
( For [3], I guess you have applied another commit:
https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/commit/?id=51261dae00f22c1fc1e324a26e9b21b87715fd58
Looks like it's in topic/twl, but it's strange I cannot find topic/twl in regulator tree now.
)

I'm wondering if I need to resend these patches?

Regards,
Axel


