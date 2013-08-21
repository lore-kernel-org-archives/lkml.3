Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3HUQxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:53:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28621 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3HUQxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:53:50 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-59-5214f09ca6b4
From: Andrzej Hajda <a.hajda@samsung.com>
To: lee.jones@linaro.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 0/2] max77693: added device tree support
Date: Wed, 21 Aug 2013 18:53:32 +0200
Message-id: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t/xa7pzPogEGUx/pmBxa905Vov5R4DE
	gT87GC3e9HawWHSefcJscbbpDbvF/a9HGS0u75rDZrH0+kUmiwnT17JYHF5xgMli3cvpQNab
	dlaL092sFq8OtrE48HusmbeG0WPB5yvsHq8nT2D0eLV6JqvHnWt72DzmnQz06NuyitHj8yY5
	j41zQwM4o7hsUlJzMstSi/TtErgyJqz6wlbwlrlib/9f9gbGb0xdjJwcEgImEj2/zjJC2GIS
	F+6tZ+ti5OIQEljKKPFj2S9GCKePSeLCxUnMIFVsApoSfzffZAOxRQQkJDb+6GMBKWIWOMUi
	Mbf1NthYYQFrid/dJ8CKWARUJe5/PAxm8wo4SzxdeIQZYp2CxM/LJ9gmMHIvYGRYxSiaWppc
	UJyUnmuoV5yYW1yal66XnJ+7iRESml92MC4+ZnWIUYCDUYmHV2OPSJAQa2JZcWXuIUYJDmYl
	Ed7Ck0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjHUTXXf5NktpTEzcvahGbZ3DlSsPP/WW+jqu
	0F7Kfrk5ryrZWeLDmtzMB58nuIkUzA5rdHKc/3qHKH9b29qYNZPPam3N1fA69nL/Dxm2x5uM
	Pu06f/55nObdjshnrSfOnJJ4HrrQeseJM9ELviy9IH1+0Z8Fk2dPmH/i/fstZx87Xl53+Wzq
	yW8flViKMxINtZiLihMB7xt85ysCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch cleans up the driver from unneccesary
wakeup handling.
The second patch adds device tree support to the driver.

Regards
Andrzej

Andrzej Hajda (2):
  max77693: remove device wakeup from driver
  max77693: added device tree support

 drivers/mfd/max77693.c               | 18 ++++++++----------
 include/linux/mfd/max77693-private.h |  1 -
 include/linux/mfd/max77693.h         |  2 --
 3 files changed, 8 insertions(+), 13 deletions(-)

-- 
1.8.1.2

