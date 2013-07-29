Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3G2H0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:26:23 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37766 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3G2H0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:26:22 -0400
Message-ID: <1375082774.7272.1.camel@phoenix>
Subject: regulator: pfuze100: A few small questions
From: Axel Lin <axel.lin@ingics.com>
To: Robin Gong <b38343@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 15:26:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robin,
2 questions about the code in pfuze100 driver:

1)
Both PFUZE100_REVID and PFUZE100_FABID are defined as 0x3.
So I'm wondering if it's a typo in one of the register address?
If they are actually the same register, we don't need to read the same
register twice in pfuze_identify().

2)
What is the the purpose of stby_reg and stby_mask?
Seems current code does not use it?


