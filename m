Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3HFJNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:13:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25609 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3HFJNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:13:02 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-e0-5200be1cb229
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] pinctrl: st: Staticize local symbols
Date: Tue, 06 Aug 2013 18:12:59 +0900
Message-id: <000201ce9285$2592b3c0$70b81b40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6ShRTgJ58FQBrXR42j/gNLOInWWQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zI12ZfQxBBhf3sVu8PKRpcXnhJVaL
	KX+WM1lc3jWHzWLKs15WB1aPO9f2sHn0bVnF6PH0x15mj8+b5AJYorhsUlJzMstSi/TtErgy
	Xh19yl5wVqBi38kjbA2M33i7GDk5JARMJM609jBB2GISF+6tZwOxhQSWMUrsvVXVxcgBVjPl
	QEQXIxdQeBGjxPWvB9khnF+MEo8unmAFaWATUJP48uUwO4gtIqAn8eZrCztIM7NAhcTkZjGQ
	sLCApUTTw0vMIDaLgKrE+fcPwcp5geLn7jeyQdiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ
	4k4FiR1nXzPCrDrxZQUbRI2IxL4X7xhBbpMQ2MUusfLZYiaIZQIS3yYfYoF4RlZi0wGoOZIS
	B1fcYJnAKDYLyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExNqE
	HYz3DlgfYkwGWj+RWUo0OR8Yq3kl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYHRnt+zbutb1eH+ERIbv6iNP5Dbd1FSPejTj5+MrRscTZabqTJOr
	P6nWIuuwZuqXDTkfE3pC/YMvd549OkvqzzaRR3EXTu74bsCw5Ma9o12CV8KqBH8GPj+qo7wv
	nO1+pdGnSxy9f/lj9VL5c9+cj15U0/ms4dXRf2FKAoGpc0Mdw/7+X6q4ZJYSS3FGoqEWc1Fx
	IgCzx7OCywIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV2ZfQxBBj1TmC1eHtK0uLzwEqvF
	lD/LmSwu75rDZjHlWS+rA6vHnWt72Dz6tqxi9Hj6Yy+zx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGa+OPmUvOCtQse/kEbYGxm+8XYwcHBICJhJTDkR0MXIC
	mWISF+6tZ+ti5OIQEljEKHH960F2COcXo8SjiydYQarYBNQkvnw5zA5iiwjoSbz52sIOMohZ
	oEJicrMYSFhYwFKi6eElZhCbRUBV4vz7h2DlvEDxc/cb2SBsQYkfk++xgNjMAloS63ceZ4Kw
	5SU2r3nLDHGQgsSOs68ZYVad+LKCDaJGRGLfi3eMExgFZiEZNQvJqFlIRs1C0rKAkWUVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRnAsP5PewbiqweIQowAHoxIPb8LV/4FCrIllxZW5hxgl
	OJiVRHhVdjIECfGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MM3klcQbGpuYGVkamVkYmZib
	kyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjzNrnrI1vtOaFX7LX8NBNmNNV1lF0//tb
	ruUf7Q2Muu3dF3XpLsuJuXdqT2a07f3aE653It/5hpndK/i4YGXRh/ak2jq/J84dJrM47p8U
	emYr4TmzSZOd+Vpy3ONNnrmTu94V+whccYiS++aunGcuml/4VyvnxEmnC9MMnDJf5sxa4Zl3
	hUeJpTgj0VCLuag4EQA/cZuYKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These local symbols are used only in this file.
Fix the following sparse warning:

drivers/pinctrl/pinctrl-st.c:291:14: warning: symbol 'stih415_input_delays' was not declared. Should it be static?
drivers/pinctrl/pinctrl-st.c:292:14: warning: symbol 'stih415_output_delays' was not declared. Should it be static?
drivers/pinctrl/pinctrl-st.c:327:14: warning: symbol 'stih416_delays' was not declared. Should it be static?
drivers/pinctrl/pinctrl-st.c:814:12: warning: symbol 'st_pmx_get_fname' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/pinctrl-st.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 04d4506..acc2b1e 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -288,8 +288,8 @@ struct st_pinctrl {
 
 /* SOC specific data */
 /* STiH415 data */
-unsigned int stih415_input_delays[] = {0, 500, 1000, 1500};
-unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
+static unsigned int stih415_input_delays[] = {0, 500, 1000, 1500};
+static unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
 
 #define STIH415_PCTRL_COMMON_DATA				\
 	.rt_style	= st_retime_style_packed,		\
@@ -324,8 +324,8 @@ static const struct st_pctl_data  stih415_right_data = {
 };
 
 /* STiH416 data */
-unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
-			1750, 2000, 2250, 2500, 2750, 3000, 3250 };
+static unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
+				1750, 2000, 2250, 2500, 2750, 3000, 3250 };
 
 static const struct st_pctl_data  stih416_data = {
 	.rt_style	= st_retime_style_dedicated,
@@ -811,7 +811,7 @@ static int st_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
 	return info->nfunctions;
 }
 
-const char *st_pmx_get_fname(struct pinctrl_dev *pctldev,
+static const char *st_pmx_get_fname(struct pinctrl_dev *pctldev,
 	unsigned selector)
 {
 	struct st_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
-- 
1.7.10.4


