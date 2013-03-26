Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824Ab3CZHFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:05:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3CZHFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:05:37 -0400
X-AuditID: cbfee690-b7f656d0000007e3-b3-515148c09728
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce29f0$3eb62f60$bc228e20$%han@samsung.com>
In-reply-to: <001e01ce29f0$3eb62f60$bc228e20$%han@samsung.com>
Subject: [PATCH 2/3] misc: bh1770glc: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Tue, 26 Mar 2013 16:05:36 +0900
Message-id: <001f01ce29f0$5097d260$f1c77720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4p8D6brC4ZHCKLQ+WHsWIzuH0C8gAAAWMg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI90DHoGBBjuPS1r8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJYoLpuU1JzMstQifbsErowfc84w
	FvznrJi8ZDlTA+NGji5GDg4JAROJ9smyXYycQKaYxIV769m6GLk4hASWMUps+f2bCSJhIrG8
	cz+YLSSwiFHi5kEmiKJfjBK/F+5mBEmwCahJfPlymB3EFhEwldj4fgpYnFkgXeLO0U6oZluJ
	Xw9nM4Is5hSwk/jUEA9iCguESzzqLACpYBFQldjc0MQMYvMCVc+ZdZAdwhaU+DH5HgvERC2J
	9TuPM0HY8hKb17xlhnhFXeLRX12IA4wkjuzaBVUuIrHvxTtGkIslBI6xS/xcvpcZYpeAxLfJ
	h1ggemUlNh1ghvhWUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IhO94sTc
	4tK8dL3k/NxNjJB4nLCD8d4B60OMyUDrJzJLiSbnA+M5ryTe0NjMyMLUxNTYyNzSjDRhJXFe
	9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M0+ZsWPhHQU627zUf91aRmmUZakUq9zX/
	LuP54vDi9lKdyXUcc9UOLtlwRMLKoVb1a6NoI3P3JFZdM4kX8RFJKznfNX1X8hOeGikYrX7c
	Q/heB5uC+Ou0v1Zr+yq99SO03q1Q6V+bpxz+JkQk9f97Y90XS94vNftjkHPXZr3lrpSHRpa5
	X8WVWIozEg21mIuKEwHwF9R23QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd0DHoGBBhOuiFr8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMH3POMBb856yYvGQ5UwPjRo4uRk4OCQETieWd+5kgbDGJC/fW
	s4HYQgKLGCVuHgSKcwHZvxglfi/czQiSYBNQk/jy5TA7iC0iYCqx8f0UsDizQLrEnaOdTBDN
	thK/Hs4GinNwcArYSXxqiAcxhQXCJR51FoBUsAioSmxuaGIGsXmBqufMOsgOYQtK/Jh8jwVi
	opbE+p3HmSBseYnNa94yg4yREFCXePRXF+IAI4kju3ZBlYtI7HvxjnECo9AsJJNmIZk0C8mk
	WUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvdnUjsYVzZYHGIU4GBU4uHdEBwQ
	KMSaWFZcmXuIUYKDWUmE949jYKAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wNTUV5JvKGx
	iZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MF6wirtxvakgMajokNDN
	peseTkx96s0fZ5p22nCfe/HjrWYMlSfiZJ8mb0k6ynpERnPinU3nPbfomU5In1nwsS7S2O5h
	+XS/i0XXu5vnP2f6W1L+VinsxltTx+cpoW2PqqbdNTwR+LM8wKamnfUWV77eNcbf3IyaqTHT
	+67xq/31fCbNOSfbUYmlOCPRUIu5qDgRAAXyL4I7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
build warning when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SET_SYSTEM_SLEEP_PM_OPS are only used
when the CONFIG_PM_SLEEP is enabled.

drivers/misc/bh1770glc.c:1314:12: warning: 'bh1770_suspend' defined but not used [-Wunused-function]
drivers/misc/bh1770glc.c:1324:12: warning: 'bh1770_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/bh1770glc.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 2ed8fc3..f4975f7 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -1310,7 +1310,7 @@ static int bh1770_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int bh1770_suspend(struct device *dev)
 {
 	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
@@ -1346,11 +1346,6 @@ static int bh1770_resume(struct device *dev)
 	}
 	return ret;
 }
-
-#else
-#define bh1770_suspend	NULL
-#define bh1770_shutdown NULL
-#define bh1770_resume	NULL
 #endif
 
 #ifdef CONFIG_PM_RUNTIME
-- 
1.7.2.5


