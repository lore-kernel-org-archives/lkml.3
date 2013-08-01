Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3HAB7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:59:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24500 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3HAB7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:59:12 -0400
X-AuditID: cbfee691-b7fef6d000002d62-37-51f9c0ef78a6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Peter Tyser'" <ptyser@xes-inc.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mfd: lpc_ich: Staticize struct 'lpc_chipset_info'
Date: Thu, 01 Aug 2013 10:59:11 +0900
Message-id: <002d01ce8e5a$b73e3030$25ba9090$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6OWldt2uDogejCRh29O5tm0rc/vQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zI933B34GGryepGRxeeElVov7X48y
	WlzeNYfN4uDztywWp7tZHVg97lzbw+Yx72SgR9+WVYwenzfJeaxqn80awBrFZZOSmpNZllqk
	b5fAlXHgyELGgkesFVvfzGBpYLzB0sXIySEhYCJx6cEUdghbTOLCvfVsILaQwDJGiUdr7WFq
	Vn9Yz9zFyAUUX8QocejcZVYI5xejxIzJ08C62QTUJL58OQxkc3CICPhJNKwACzMLZEk8PzIR
	zBYWcJJofrAUzGYRUJV42H6YGcTmFbCUWN1/nw3CFpT4MfkeC0SvlsT6nceZIGx5ic1r3jJD
	HKQgsePsa0YQW0RAT2LBo72sEDUiEvtevGMEuU1CYB+7xI5NDcwQywQkvk0+xAJym4SArMSm
	A1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/d
	xAiJuok7GO8fsD7EmAy0fiKzlGhyPjBq80riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8s
	Sc1OTS1ILYovKs1JLT7EyMTBKdXAmBKjkhHrce6XaX7gu5OMPIdWGf1+ciaAl6d9fsWKPK71
	xXsv7nh/SMSW1Wl98GmVCGbJoJVhLFtvL6q7cChGwEPw34up5f1yU4+U5s89turx+8ydCR0W
	s2OmxfUnH9TUzLjEvdU6W3aTodLcCa19TXu+v0le0uQ9YSb7qxr5htuPF63f8UhCWYmlOCPR
	UIu5qDgRAHmh+WPQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd33B34GGlycJ2dxeeElVov7X48y
	WlzeNYfN4uDztywWp7tZHVg97lzbw+Yx72SgR9+WVYwenzfJeaxqn80awBrVwGiTkZqYklqk
	kJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RbSaEsMacUKBSQWFys
	pG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx4MhCxoJHrBVb38xgaWC8wdLFyMkhIWAisfrD
	emYIW0ziwr31bF2MXBxCAosYJQ6du8wK4fxilJgxeRo7SBWbgJrEly+HgWwODhEBP4mGFWBh
	ZoEsiedHJoLZwgJOEs0PloLZLAKqEg/bD4Mt4BWwlFjdf58NwhaU+DH5HgtEr5bE+p3HmSBs
	eYnNa95CHaQgsePsa0YQW0RAT2LBo72sEDUiEvtevGOcwCgwC8moWUhGzUIyahaSlgWMLKsY
	RVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqP6mfQOxlUNFocYBTgYlXh4M7b+DBRiTSwrrsw9
	xCjBwawkwrs1HSjEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cCEk1cSb2hsYmZkaWRmYWRi
	bk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjNGeAUdW67bOz0x58i/mue61RTcffVHL
	LNfieJLI8aDjd6rjkScLbgu9ceHZ+qzy9ZwzMZWJzN/5V8j4rZFancT+8sa2uvLfh5/9Xr/8
	mcj6Q3enHrlwLkvt/bWorjgblbvv3q69ck5/yaepppMypTl3mpyunV1Qztnz5/TUr5k3PnJ+
	5px+9VasEktxRqKhFnNRcSIAeHUkgi4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'lpc_chipset_info' is used only in this file.

Fix the following sparse warning:

drivers/mfd/lpc_ich.c:216:21: warning: symbol 'lpc_chipset_info' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/lpc_ich.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 2403332..9483bc8 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -213,7 +213,7 @@ enum lpc_chipsets {
 	LPC_COLETO,	/* Coleto Creek */
 };
 
-struct lpc_ich_info lpc_chipset_info[] = {
+static struct lpc_ich_info lpc_chipset_info[] = {
 	[LPC_ICH] = {
 		.name = "ICH",
 		.iTCO_version = 1,
-- 
1.7.10.4


