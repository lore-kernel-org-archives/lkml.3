Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3EFDkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:40:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3EFDkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:40:16 -0400
X-AuditID: cbfee68d-b7f016d000007930-eb-5187261fabf0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/4] pinctrl: coh901: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:40:14 +0900
Message-id: <001e01ce4a0b$6b8e32e0$42aa98a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KCzQpoPcMdb4hSrmmUwyL6vpzhQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zfV15tfZAg5mTRS0uL7zEajHlz3Im
	i8u75rA5MHvcubaHzaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyWj6JFtxjq+h53c3SwHiV
	tYuRk0NCwETiweMb7BC2mMSFe+vZuhi5OIQEljFKTG99zART9OpcDyNEYjqjxIePO5ghnF+M
	EhPO/wUbxSagJvHly2GwUSICehJvvrYA2RwczAIuEkeniYCEhQX8JVYd6WcDsVkEVCUWXVjD
	DGLzClhK7H69jxHCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBAHKUjsOPuaEWbV0VOP2SBq
	RCT2vXgHdqiEwCJ2idO/DjNDLBOQ+Db5EAvIPRICshKbDkDNkZQ4uOIGywRGsVlIVs9CsnoW
	ktWzkKxYwMiyilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkonp3MN4+YH2IMRlo/URmKdHk
	fGBE5pXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	Uer4pp8bpY75nSvVu5a8xfP4S46HKu4/OaP3dyRGx3PYvJ5eneAXkz2/Uk/+2rl8E40lf286
	37HzTDpYN3XOoZQkyxQz9Y1ec+/MOHTinN2JS9cDBXk+xp4Rf3yxxjutafrWSdJOS1Lu/z0/
	0aRq0901f/4oz7IKWjyrM+rQYWnT0iC92ZYvpyixFGckGmoxFxUnAgD4W4OSvgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoK68WnugwZJzghaXF15itZjyZzmT
	xeVdc9gcmD3uXNvD5tG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGS2fRAvusVX0vO5maWC8ytrFyMkhIWAi8epcDyOELSZx4d56ti5GLg4hgemMEh8+
	7mCGcH4xSkw4/xesg01ATeLLl8PsILaIgJ7Em68tQDYHB7OAi8TRaSIgYWEBf4lVR/rZQGwW
	AVWJRRfWMIPYvAKWErtf72OEsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPEQQoSO86+ZoRZ
	dfTUYzaIGhGJfS/eMU5gFJiFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6
	yfm5mxjB8fpMagfjygaLQ4wCHIxKPLwFT9oChVgTy4orcw8xSnAwK4nw+uwFCvGmJFZWpRbl
	xxeV5qQWH2JMBvp0IrOUaHI+MJXklcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1
	tSC1CGYLEwenVANj5qbXGr93sbs87lAW8P62zTXTM/TT3VRJ+Wu3c/nN9+3dkdB/dptfee2v
	R8w5v3xOvZ2Vm8eZJbAjdr5fUVH1Xrb6L7kHZj7anyQ/tVpyncObaJUFdqpFooJPbyf8m//w
	jOO6LQ3X6p/kpjUzz2Kp/aNwY7ZF0sGt7NH3a9M8v/w5L2xygJFLiaU4I9FQi7moOBEABA2c
	9RsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/pinctrl-coh901.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index edde3ac..f12546b 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -860,7 +860,6 @@ static int __exit u300_gpio_remove(struct platform_device *pdev)
 	}
 	u300_gpio_free_ports(gpio);
 	clk_disable_unprepare(gpio->clk);
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


