Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab3HUJVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:21:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10455 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3HUJVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:21:31 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-30-5214869a0729
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Magnus Damm'" <damm@igel.co.jp>,
        "'Paul Mundt'" <lethal@linux-sh.org>,
        "'Simon Horman'" <horms+renesas@verge.net.au>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] clocksource: sh_tmu: remove unnecessary
 platform_set_drvdata()
Date: Wed, 21 Aug 2013 18:21:29 +0900
Message-id: <001b01ce9e4f$d1c97950$755c6bf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6eT9Gw4QMTlzEDTGKp7zWeUER7Lw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zA91ZbSJBBveb+C0mTJrAaDHvs6zF
	hbcf2CwuL7zEarH/7U9Wi8u75rBZbN40ldmB3aPxuYTHnWt72DzenTvH7nH6/SFWj74tqxg9
	5vz8xuLxeZNcAHsUl01Kak5mWWqRvl0CV8aSy5vZCs6xVvy9doixgfE0SxcjJ4eEgInExr8P
	mSBsMYkL99azdTFycQgJLGOUWHdmDTNM0ZWmlcwQiemMEo+/NbFAOL8YJXbPB2nh5GATUJP4
	8uUwO4gtImAg8fr0b3aQImaBR4wS13/vAisSFgiVeDlvFlCCg4NFQFWi/7MYSJhXwFaib8JZ
	ZghbUOLH5Htg5zELaEms33mcCcKWl9i85i0zSKuEgLrEo7+6EKv0JJZvnMYOUSIise/FO0aQ
	tRIC99gllp54zAqSYBEQkPg2+RALRK+sxKYDUI9JShxccYNlAqPYLCSbZyHZPAvJ5llIVixg
	ZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERKfvTsYbx+wPsSYDLR+IrOUaHI+ML7zSuIN
	jc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDoID05467q
	qcKdd4z/JVWp81+eNEG+qvTmaxZPIeUdZd4Nb+Y/CqwOWaG5XI3pWpjl+SzVYAXd/63Lpq3Z
	k3H1cF5U6mm2SD7GfR/8uxozJk7fbWMufNh5l9aPbzmW8UYZ70/NPjjV3SRjfWbVPOPQJWKP
	0xs+qq6qvpMnNGGJ38JGsTnBO/WUWIozEg21mIuKEwEDzJFK5QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd1ZbSJBBj9PcllMmDSB0WLeZ1mL
	C28/sFlcXniJ1WL/25+sFpd3zWGz2LxpKrMDu0fjcwmPO9f2sHm8O3eO3eP0+0OsHn1bVjF6
	zPn5jcXj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
	F58AXbfMHKB7lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZSy5vZis4
	x1rx99ohxgbG0yxdjJwcEgImEleaVjJD2GISF+6tZ+ti5OIQEpjOKPH4WxMLhPOLUWL3fJAM
	JwebgJrEly+H2UFsEQEDidenf7ODFDELPGKUuP57F1iRsECoxMt5s4ASHBwsAqoS/Z/FQMK8
	ArYSfRPOMkPYghI/Jt8Du4JZQEti/c7jTBC2vMTmNW+ZQVolBNQlHv3VhVilJ7F84zR2iBIR
	iX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwdH/
	THoH46oGi0OMAhyMSjy8F5RFgoRYE8uKK3MPMUpwMCuJ8C6qBgrxpiRWVqUW5ccXleakFh9i
	TAb6cyKzlGhyPjAx5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMH
	p1QDY+ty9e3MBi8/bX0wj7vi1tb+8IzpWQZ/XG4eObNA+eRzl5nBh7SO+1nm+U/sXrgtRDG7
	IubefA6HqOnr1rRrvJ7yMkKq9orSfd5c/7uSTwz28zJ/WBTyztic2a/MQmj6geocLsXAjUZc
	ZQGGIef2uN5Yl9KkHHP9aQDHWoYiIRazZ7zLZ6jPU2Ipzkg01GIuKk4EAGrNPzJCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/clocksource/sh_tmu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 78b8dae..54ab475 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -509,7 +509,6 @@ static int sh_tmu_probe(struct platform_device *pdev)
 	ret = sh_tmu_setup(p, pdev);
 	if (ret) {
 		kfree(p);
-		platform_set_drvdata(pdev, NULL);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
-- 
1.7.10.4


