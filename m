Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaEGIGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:06:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30817 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaEGIGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:06:36 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-0e-5369e98a36f4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
References: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
In-reply-to: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
Subject: [PATCH 2/5] regulator: max8952: Make of_device_id array const
Date: Wed, 07 May 2014 17:06:34 +0900
Message-id: <01ec01cf69cb$430ae9e0$c920bda0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pyau3FkiFWFjRR4iSx3x0aUKqEQAAWn/A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zfd2ul5nBBod+6VhMffiEzeLywkus
	Fq9fGFp8u9LBZHF51xw2B1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	v76+YCpYyFqx6tJMlgbGVSxdjJwcEgImEl/fv2KGsMUkLtxbz9bFyMUhJLCMUWLljFVMMEXX
	9t2GSkxnlJjeNYcZwvnNKHH98Xp2kCo2ATWJL18OA9kcHCICqhL/X7mD1DALLGCUWHZ+BytI
	XEjAVuLRnnqQck4BO4mGbVPZQGxhATeJZ/c/soLYLECty64uA7uOF6h81taTjBC2oMSPyffA
	4swCWhLrdx5ngrDlJTavecsMMl5CQF3i0V9dkLCIgJHE6redbBAlIhL7XrxjBDlHQuAau0TP
	5c8sELsEJL5NPsQC0SsrsekANCAkJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4o
	TkovMtUrTswtLs1L10vOz93ECInOiTsY7x+wPsSYDLR+IrOUaHI+MLrzSuINjc2MLExNTI2N
	zC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoExY7Gx5au5f4VbTPO1t3Od
	i6let9rsC4N92KqkghzTys8P57PMev/CISWm2vbJp1uaG1dGmyxqNb0+9cjLCY6Ppz9YKvg4
	U3d2vp92b/HTI/3ZfGZaiu8qNL0U4p+KpFcHKKzczyShKp/N4frSK1cq9nTWu7gAX9WtW+SK
	ztmm/L13My01hlGJpTgj0VCLuag4EQDhE5685AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd2ul5nBBpdPa1hMffiEzeLywkus
	Fq9fGFp8u9LBZHF51xw2B1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGb++vmAqWMhaserSTJYGxlUsXYycHBICJhLX9t1mg7DF
	JC7cWw9kc3EICUxnlJjeNYcZwvnNKHH98Xp2kCo2ATWJL18OA9kcHCICqhL/X7mD1DALLGCU
	WHZ+BytIXEjAVuLRnnqQck4BO4mGbVPBFggLuEk8u/+RFcRmAWpddnUZ2BG8QOWztp5khLAF
	JX5MvgcWZxbQkli/8zgThC0vsXnNW2aQ8RIC6hKP/uqChEUEjCRWv+1kgygRkdj34h3jBEah
	WUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERz7z6R3MK5qsDjE
	KMDBqMTDa/E2I1iINbGsuDL3EKMEB7OSCO+ui5nBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwl
	mpwPTEt5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCY4rXH
	/oFzRJj9TsXNtkv+TLzI9qUslz19icdJiw3J+2/X1/+VtH8nUGVU3NketMzXbtqnDabnj5Vn
	OMatiWdRF6tfybryaK1J2Rved36/yg4q6/f8cWHxrBX1X786q9rQqOWbXl/DmdfvHfPWWX5L
	O9Tw5uIt71XqWl+evygXvPrF5jTHIlElluKMREMt5qLiRAA4No7oQQMAAA==
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
 drivers/regulator/max8952.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index d920f5a..c2792f0 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -129,7 +129,7 @@ static const struct regulator_desc regulator = {
 };
 
 #ifdef CONFIG_OF
-static struct of_device_id max8952_dt_match[] = {
+static const struct of_device_id max8952_dt_match[] = {
 	{ .compatible = "maxim,max8952" },
 	{},
 };
-- 
1.7.10.4


