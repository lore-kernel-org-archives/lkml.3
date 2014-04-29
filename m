Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaD2FYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:24:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12684 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaD2FYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:24:07 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-c2-535f3774f7ed
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: open list <linux-kernel@vger.kernel.org>
Cc: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Len Brown'" <len.brown@intel.com>
Subject: [PATCH 1/2] PM / OPP: Use list_for_each_entry_reverse instead of
 list_for_each_entry
Date: Tue, 29 Apr 2014 14:24:03 +0900
Message-id: <000601cf636b$3c2b39b0$b481ad10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jasDSuwbkUkedTjGpKnGrrJit1g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zfd0S8/hgg0kfOS1mTdnLZHF51xw2
	izOnL7E6MHss3vOSyWPL1XYWj8+b5AKYo7hsUlJzMstSi/TtErgyLt7pYivoZq/Ys7qbrYHx
	I2sXIyeHhICJxPZZfSwQtpjEhXvr2boYuTiEBJYxSlz58Y8dpujqtSfsEInpjBITfx6Ccv4x
	SjyfN5ERpIpNQFfi2PotYGNFBHQkpu9rACri4GAWCJD4vMMTJCwsEC8xbcN6sG0sAqoSy8+8
	AbN5BSwlrs3ezQxhC0r8mHwPLM4soCWxfudxJghbXmLzmrfMEAcpSOw4+5oRYpWexPebzxkh
	akQk9r14xwhym4TAMnaJad83s0MsE5D4NvkQC8g9EgKyEpsOQM2RlDi44gbLBEaxWUhWz0Ky
	ehaS1bOQrFjAyLKKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIySmJu5gvH/A+hBjMtD6icxS
	osn5wJjMK4k3NDYzsjA1MTU2Mrc0I01YSZw3/VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQZGtndnz+1Q3fcilvvdRD6p/j9y7+7O//puqX/NATWLuJ9JFzsly0vsc+VXieVFPX097eOa
	yYevbfAtMkk7+ND88vPtcX8mvoizX3lwIaffNJv1DDcq39x4+lns8qH9d9pXbpL/8qsg7c53
	AbW06TuTE+YcCMrrvH13T33vER7FPczy544uL1imwa/EUpyRaKjFXFScCAB2Nd5HvwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoG6JeXywwe95bBazpuxlsri8aw6b
	xZnTl1gdmD0W73nJ5LHlajuLx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGRfvdLEVdLNX7FndzdbA+JG1i5GTQ0LAROLqtSfsELaYxIV769m6GLk4hASmM0pM
	/HmIHcL5xyjxfN5ERpAqNgFdiWPrt4B1iwjoSEzf1wBUxMHBLBAg8XmHJ0hYWCBeYtqG9Swg
	NouAqsTyM2/AbF4BS4lrs3czQ9iCEj8m3wOLMwtoSazfeZwJwpaX2LzmLTPEQQoSO86+ZoRY
	pSfx/eZzRogaEYl9L94xTmAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGMER+0xqB+PKBotDjAIcjEo8vAZRccFCrIllxZW5hxglOJiVRHhjDeKDhXhTEiur
	Uovy44tKc1KLDzEmA306kVlKNDkfmEzySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliS
	mp2aWpBaBLOFiYNTqoExhCnXgjdnUzObh+i24h+6zoludnlnbufqbHonySYR8+HuEqMP0zQO
	618+o/k4qsxprvxZ9lsmHsceSi/7+vpAnPu0q1kN3zLedO52WhfPtvXKq7RPNikL10++E/Dr
	3TlpYXuxStXZD35q9e8vXv8qeUk5W8TNp5rsLEoKdifzNIoclzi1/i5RYinOSDTUYi4qTgQA
	9QFiSBwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the cpufreq table is sorted in descending order.
But when cpufreq table is made from dev_pm_opp_init_cpufreq_table,
it is sorted in ascending order. So in some case to make cpufreq table
with descending order it needs an extra work.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/base/power/opp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 2553867..8d81a46 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -649,7 +649,7 @@ int dev_pm_opp_init_cpufreq_table(struct device *dev,
 		return -ENOMEM;
 	}
 
-	list_for_each_entry(opp, &dev_opp->opp_list, node) {
+	list_for_each_entry_reverse(opp, &dev_opp->opp_list, node) {
 		if (opp->available) {
 			freq_table[i].driver_data = i;
 			freq_table[i].frequency = opp->rate / 1000;
-- 
1.7.10.4

