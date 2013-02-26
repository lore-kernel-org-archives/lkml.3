Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab3BZCeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:34:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62250 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab3BZCeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:34:11 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-6b-512c1f1ff9d9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] pinctrl: core: use devres_release() instead of devres_destroy()
Date: Tue, 26 Feb 2013 11:34:07 +0900
Message-id: <009401ce13c9$c01f6400$405e2c00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Tyb/4JeS6474XT7S/qFgAgM0u5g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zA115eZ1Ag7VfZC0uL7zEajHlz3Im
	i8u75rA5MHvcubaHzaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyli3/xFawna3i9p95LA2M
	a1m7GDk5JARMJBauu88OYYtJXLi3nq2LkYtDSGAZo8Tpq1/hiv69ms4MkZjOKDHv+BImCOcX
	o8SEy5+YQarYBNQkvnw5DDZKREBP4s3XFiCbg4NZwEXi6DQREFNYIEDiVFsFiMkioCpx5qcz
	SDGvgK3E5YUP2SFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDNIqIaAu8eivLsyenVv2QZWL
	SOx78Y4R5DAJgUXsEoePnmcDSbAICEh8m3yIBaJXVmLTAWaIryQlDq64wTKBUWwWks2zkGye
	hWTzLCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIiaa+HYw3D1gfYkwGWj+RWUo0
	OR8YjXkl8YbGxiZmJqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wOj+jPfx0msub7LSE1oKY+K+7zH7vujJCy4zVcbs5Qv/7El7uPnS147DEnFfFDrTXq46+PFI
	3CQziVLJGTu2ss53/bT3TBbbkpVWKf5Nc64pXpqZ29x3dlXG0amLL3To71th+Fl/onRR072H
	k3exT5u56m2BgJvJIsGpIV+n5uT925vXGv/7wtP9SizFGYmGWsxFxYkAoplCYrwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xoK68vE6gQVujlMXlhZdYLab8Wc5k
	cXnXHDYHZo871/awefRtWcXo8XmTXABzVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QJiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1G
	BmggYR1jxrLln9gKtrNV3P4zj6WBcS1rFyMnh4SAicS/V9OZIWwxiQv31rN1MXJxCAlMZ5SY
	d3wJE4Tzi1FiwuVPYFVsAmoSX74cZgexRQT0JN58bQGyOTiYBVwkjk4TATGFBQIkTrVVgJgs
	AqoSZ346gxTzCthKXF74kB3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCCtEgLqEo/+6sLs
	2bllH1S5iMS+F+8YJzAKzEIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOBYfSa1g3Flg8UhRgEORiUe3gQWnUAh1sSy4srcQ4wSHMxKIrycGdqBQrwpiZVVqUX5
	8UWlOanFhxiTgf6cyCwlmpwPTCN5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2a
	WpBaBLOFiYNTqoFx/4+vsl8WGLos+B2/3rr65nabm/LbeUWXOMRwNin0afG/E1ia5fc2TkLU
	Nd5+xnMF2WtyL26c+fk2KWn/3l3ZpaUn+kIeL7LRfdC+RTbgz96zoZdZ9b2FBH5/+LwnTif1
	yKbg8ixPca7/Hp5Sj/7mhr3sy707IzEtt2bDp8O+tQfWqoRs2/BXiaU4I9FQi7moOBEAbPAY
	ExkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devres_release() can simplify the code, because devres_release()
will call the destructor for the resource as well as freeing
the devres data.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index b0de6e7..e2d214c 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -979,9 +979,8 @@ static int devm_pinctrl_match(struct device *dev, void *res, void *data)
  */
 void devm_pinctrl_put(struct pinctrl *p)
 {
-	WARN_ON(devres_destroy(p->dev, devm_pinctrl_release,
+	WARN_ON(devres_release(p->dev, devm_pinctrl_release,
 			       devm_pinctrl_match, p));
-	pinctrl_put(p);
 }
 EXPORT_SYMBOL_GPL(devm_pinctrl_put);
 
-- 
1.7.2.5


