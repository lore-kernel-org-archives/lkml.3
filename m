Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaLCMlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:41:13 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26233 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaLCMlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:41:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-28-547f04e413e6
From: Kamil Debski <k.debski@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>, linux-media@vger.kernel.org
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "'Mauro Carvalho Chehab'" <m.chehab@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Philipp Zabel'" <p.zabel@pengutronix.de>,
        "'Linux PM list'" <linux-pm@vger.kernel.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <4139875.fkJ48z9AaU@vostro.rjw.lan>
In-reply-to: <4139875.fkJ48z9AaU@vostro.rjw.lan>
Subject: RE: [PATCH] media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 13:41:07 +0100
Message-id: <013001d00ef6$6945a520$3bd0ef60$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAOm8+iCPegt5LeSjGCW08BoBI2hwAWVHsQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7pPWOpDDFZMVbLoXXCVzeJs0xt2
	i8u75rBZ9GzYymrxufcIo8WM8/uYLC6uk7e4e+8Ei8WZ05dYLQ6/aWd14PLo/2vgseVqO4tH
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZTS3rGAr2MJV8W7vPpYGxh0cXYycHBICJhI77z1g
	h7DFJC7cW8/WxcjFISSwlFHi6f/zjBBOA5PEuifzgTIcHGwCmhKr7nmANIgIeEm82PqPGaSG
	WeAzk8TuV/OZQRJCAvoSi168YQWxOQUMJCZMX88IYgsLeEps6nvBBmKzCKhKnFi9GszmFXCQ
	uHj/ABOELSjxY/I9FpBdzALqElOm5IKEmQXkJTavecsMEpYACj/6qwtxgpHE+QlPmCBKRCTu
	NjxnncAoNAvJoFkIg2YhGTQLSccCRpZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGR82UH
	4+JjVocYBTgYlXh4FabUhQixJpYVV+YeYpTgYFYS4X32DSjEm5JYWZValB9fVJqTWnyIkYmD
	U6qB0fvAhmePRLhTWR4frWaysNbOUmbLqNsry79tmajGOavDN7b9qBc/wd57o/tQ2h6NafxP
	f1gKbPmtGFMqfmHeWtfvv66vjvzw7du9E//e+xzkMD7yaruOmbH3Y/6yv0d4jt1O/Lpme4Nj
	zqU4yxfBKY1z91jusepzN1r5r8N95earEo8Zl2SmxyuxFGckGmoxFxUnAgDKSGepegIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Wednesday, December 03, 2014 3:14 AM
> To: linux-media@vger.kernel.org
> Cc: Kyungmin Park; Sylwester Nawrocki; Mauro Carvalho Chehab; Kukjin
> Kim; linux-samsung-soc@vger.kernel.org; Kamil Debski; Philipp Zabel;
> Linux PM list; Linux Kernel Mailing List
> Subject: [PATCH] media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> replaced with CONFIG_PM too.
> 
> Make these changes everywhere under drivers/media/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME
> if
> PM_SLEEP is selected) which is only in linux-next at the moment (via
> the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

Looks good, for the s5p_mfc part,
Acked-by: Kamil Debski <k.debski@samsung.com>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


