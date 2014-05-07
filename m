Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaEGIIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:08:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48665 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaEGIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:08:37 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-27-5369ea03314a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
References: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
In-reply-to: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
Subject: [PATCH 4/5] regulator: st-pwm: Make of_device_id array const
Date: Wed, 07 May 2014 17:08:35 +0900
Message-id: <01ee01cf69cb$8b558930$a2009b90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pyau3FkiFWFjRR4iSx3x0aUKqEQAAckbQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY13mV5nBBnu3aVtMffiEzeLywkus
	Fve/HmW0+Halg8ni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CVsWDDK5aC+6wVLUfWMzYwPmLpYuTkkBAwkZj45AYrhC0mceHeerYuRi4OIYFljBK3
	57xjhClqn/eQCSKxiFFi2dcWZgjnN6PEyzXbmECq2ATUJL58OczexcjBISKgKvH/lTtImFlg
	IqPEsz2uIGEhAVuJR3vqQcKcAnYSDdumsoHYwgKuEr0728AOYgHqnL6xA2wvL1D5y4cXmCBs
	QYkfk++xQIzUkli/8zgThC0vsXnNW2aQ8RIC6hKP/uqChEUEjCQ+zdjEBlEiIrHvBcgrXEAl
	t9gltnYdYoTYJSDxbfIhFoheWYlNB5gh3pWUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopR
	NLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJE4n7mC8f8D6EGMy0PqJzFKiyfnAOM8riTc0NjOy
	MDUxNTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbSnMgzp2xsL3MV
	vpeouxG/0mae1o+dt5+Kf3vwjkF39ZcN3CfF35vP826quMJ65PV2zo0v/y1KcmR55RpVFf84
	/Slj+eoHJ94IBD4qcdy7dUn8igVx0cyP01rm2pjYa/mnv3NdX/Y+0Vfg6H7rLIPHDeafU/+W
	bN8ZtrViotqS1GcWH8IS3zgqsRRnJBpqMRcVJwIA3kKnRukCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAV3mV5nBBpM2qVtMffiEzeLywkus
	Fve/HmW0+Halg8ni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLFgwyuWgvusFS1H1jM2MD5i6WLk5JAQMJFo
	n/eQCcIWk7hwbz1bFyMXh5DAIkaJZV9bmCGc34wSL9dsA6tiE1CT+PLlMHsXIweHiICqxP9X
	7iBhZoGJjBLP9riChIUEbCUe7akHCXMK2Ek0bJvKBmILC7hK9O5sA9vLAtQ5fWMHI4jNC1T+
	8uEFJghbUOLH5HssECO1JNbvPM4EYctLbF7zlhlkvISAusSjv7ogYREBI4lPMzaxQZSISOx7
	8Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Cz6R2
	MK5ssDjEKMDBqMTDa/E2I1iINbGsuDL3EKMEB7OSCO+ui5nBQrwpiZVVqUX58UWlOanFhxiT
	gR6dyCwlmpwPTFB5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp
	1cBor1NR7iPAr3lwhtjlurrNkiteGSxuTUjpyTT41WvScVW+uuLYzSgjEc9y0btLHqSpVfKk
	lB2enF0+Q7VfIGbDwsyrWQK7H1rvXurfMbf5duGFfyn6h54scO5eyGaefcS98kRlUqBNwdSu
	7n8aLEGuldrdR7RF2y23Wq7dKLWAp7rVJ5XzixJLcUaioRZzUXEiAFwMvGpGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/st-pwm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/st-pwm.c b/drivers/regulator/st-pwm.c
index e367af1..5ea78df 100644
--- a/drivers/regulator/st-pwm.c
+++ b/drivers/regulator/st-pwm.c
@@ -118,7 +118,7 @@ static const struct st_pwm_regulator_pdata b2105_info = {
 	.duty_cycle_table = b2105_duty_cycle_table,
 };
 
-static struct of_device_id st_pwm_of_match[] = {
+static const struct of_device_id st_pwm_of_match[] = {
 	{ .compatible = "st,b2105-pwm-regulator", .data = &b2105_info, },
 	{ },
 };
-- 
1.7.10.4


