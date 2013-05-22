Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3EVEzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:55:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61949 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3EVEze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:55:34 -0400
X-AuditID: cbfee68e-b7f276d000002279-9b-519c4fc51b57
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Mark Brown'" <broonie@sirena.org.uk>,
        "'Axel Lin'" <axel.lin@ingics.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable]  regulator: mc13892: Fix MC13892_SWITCHERS0_SWxHI
 bit in set_voltage_sel
Date: Wed, 22 May 2013 13:55:32 +0900
Message-id: <007601ce56a8$97232380$c5696a80$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAGq8R4A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zQ92j/nMCDfpmCFgcmfOV2eLbrmZW
	iyXN3BaXd81hs1iw8RGjA6tH288yj74tqxg9Dt5cz+LxeZNcAEsUl01Kak5mWWqRvl0CV8aT
	1k+sBf08FU1rW1kbGFu5uhg5OSQETCTa7p1ngbDFJC7cW8/WxcjFISSwjFGit2M5I0zRj0OX
	mCAS0xkl7n3aDuX8ZZSYNe8/WBWbgK7EsfVbWEFsEQFviVNTfjF3MXJwMAukSOyeagtiCglw
	S6xuDgKp4BTgkVj3p5MZxBYWSJM4ev842BEsAqoSk3cfZAOxeQXsJNqXXmOFsAUlfky+B1bD
	LKAlsX7ncSYIW15i85q3YJskBNQlHv3VhTigQmLywV5miBIRiX0v3jGCXCwhcIld4vySt6wQ
	uwQkvk0+xALRKyux6QAzxLuSEgdX3GCZAPQbks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y
	0itOzC0uzUvXS87P3cQIicy+HYw3D1gfYkwGWj+RWUo0OR8Y2Xkl8YbGZkYWpiamxkbmlmak
	CSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYCxZuvuCzcHIHS8VfDbZTvo7l+P2
	t13HOAO39Z0xtFzyPzuyvPWdOPu2809WXQnmm9ef5DLh4fP9YmdDPr0S3h8vHJClb32noZxN
	dsmnTqG55nva+Ytfy7Dbtpuun3m14bzvh+uxb/8u+BfL2KtoZDh76e01WT3zVx5z+POUN/yO
	2RmmueUS1k+VWIozEg21mIuKEwHLyRua4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd2j/nMCDS794bY4Mucrs8W3Xc2s
	FkuauS0u75rDZrFg4yNGB1aPtp9lHn1bVjF6HLy5nsXj8ya5AJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCOsaMJ62fWAv6eSqa1rayNjC2cnUxcnJICJhI/Dh0iQnCFpO4
	cG89WxcjF4eQwHRGiXuftjNBOH8ZJWbN+88IUsUmoCtxbP0WVhBbRMBb4tSUX8xdjBwczAIp
	Erun2oKYQgLcEqubg0AqOAV4JNb96WQGsYUF0iSO3j/OAmKzCKhKTN59kA3E5hWwk2hfeo0V
	whaU+DH5HlgNs4CWxPqdx5kgbHmJzWvegm2SEFCXePRXF+KAConJB3uZIUpEJPa9eMc4gVFo
	FpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMf9M6kdjCsbLA4x
	CnAwKvHwPqidHSjEmlhWXJl7iFGCg1lJhDfaZ06gEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJ
	JucDU1JeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTCGK+ps
	S83e4hejYprJbJqanHY35tauN+H9+VLfi+ef79z8z5hJTnuH7YMWC5Npct1BKxxaXbNu5+wT
	Kez55LOzo/to7Nl3mWZ7XhXkrpH9ecb21GFjJq0/d9vsmrb+q+DZfCiwsO2QU+fUp3+FJTap
	GosY/XxhyV8bdvC4B1uHQoz77UcpoUosxRmJhlrMRcWJAEVFnDA/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Axel Lin <axel.lin@ingics.com>"

commit 78040b630f28298e0ecb56bf1bc53c7976314eab upstream

It is necessary to clear MC13892_SWITCHERS0_SWxHI bit when set voltage to
the
voltage range from 1100000 to 1375000. Leaving MC13892_SWITCHERS0_SWxHI bit
untouched may result in wrong voltage setting.

For example, currently switch voltage from 1400000 to 1300000 will set the
voltage to 1800000 because the HI bit is still set.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/regulator/mc13892-regulator.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c
b/drivers/regulator/mc13892-regulator.c
index 9891aec..cc76c52 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -465,13 +465,13 @@ static int mc13892_sw_regulator_set_voltage_sel(struct
regulator_dev *rdev,
 	 */
 
 	if (mc13892_regulators[id].vsel_reg != MC13892_SWITCHERS0) {
+		mask |= MC13892_SWITCHERS0_SWxHI;
+
 		if (volt > 1375000) {
 			reg_value -= MC13892_SWxHI_SEL_OFFSET;
 			reg_value |= MC13892_SWITCHERS0_SWxHI;
-			mask |= MC13892_SWITCHERS0_SWxHI;
-		} else if (volt < 1100000) {
+		} else {
 			reg_value &= ~MC13892_SWITCHERS0_SWxHI;
-			mask |= MC13892_SWITCHERS0_SWxHI;
 		}
 	}
 
-- 
1.7.9.

