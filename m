Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3HFJKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:10:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20144 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3HFJKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:10:22 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-af-5200bd7d02e9
From: Jingoo Han <jg1.han@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/3] pinctrl: pinconf: fix comparison of different types
Date: Tue, 06 Aug 2013 18:10:20 +0900
Message-id: <000001ce9284$c6bd34b0$54379e10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6ShJAvZeypDe8nTfybSBQ7y3Zp9g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zI93avQxBBgtvSFpcXniJ1WLKn+VM
	Fpd3zWFzYPa4c20Pm0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlHNnYx1qwgK1izqe/LA2M
	c1i7GDk5JARMJC48/ABli0lcuLeerYuRi0NIYBmjxPb7l9hgimZ8vsMMkVjEKPF7z34o5xej
	xL/mo2DtbAJqEl++HGYHsUUEdCS6t/0EizMLOEn83DKTBcQWFvCQmDDpC1gNi4CqxLqGbkYQ
	m1fAUqJ/71kmCFtQ4sfkeywQvVoS63ceZ4Kw5SU2r3nLDHGRgsSOs6+BejmAdulJzNwPVS4i
	se/FO0aQ2yQElrFLTFt+kRVil4DEt8mHWEDqJQRkJTYdgBojKXFwxQ2WCYxis5BsnoVk8ywk
	m2chWbGAkWUVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRkhMTdjBeO+A9SHGZKD1E5mlRJPz
	gTGZVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	hTvebZp4V+TFgs/5076dXOn+ZslRRvk9E1J07hmvrg9e+KR4ysW2jd1hM7qe2C2wrH5j7bKV
	zzx2XvXm23v27Qmsm+KzcXVU5LbwR++8Z+ikf1+3a+XvAq39taeDuLLvq89ZvEn2lMMZD4lP
	PH8+G3R6V0y/ojJph/KULnWhPU4X/gS1vVXrqFJiKc5INNRiLipOBACbCwpRvwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgG7tXoYgg+2dYhaXF15itZjyZzmT
	xeVdc9gcmD3uXNvD5tG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGUc29rEWLGCrmPPpL0sD4xzWLkZODgkBE4kZn+8wQ9hiEhfurWfrYuTiEBJYxCjx
	e89+ZgjnF6PEv+ajYB1sAmoSX74cZgexRQR0JLq3/QSLMws4SfzcMpMFxBYW8JCYMOkLWA2L
	gKrEuoZuRhCbV8BSon/vWSYIW1Dix+R7LBC9WhLrdx5ngrDlJTaveQt1kYLEjrOvgXo5gHbp
	SczcD1UuIrHvxTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85
	P3cTIzhin0ntYFzZYHGIUYCDUYmHN/Hq/0Ah1sSy4srcQ4wSHMxKIrwqOxmChHhTEiurUovy
	44tKc1KLDzEmAz06kVlKNDkfmEzySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2a
	WpBaBLOFiYNTqoFxG1Nvg9jCtX2SG/wOPVry+Pzxjcl93A9uTjvx+fjhV58TJt9Z3Fp1uKXQ
	PFtj24I3OzyO5qu+qfq4R3DJjv4jd6ZohXYpHZ51aadpVfU0x9nPDFWqeiL2HH8RcMnVR6t8
	fSrfbz3+GcpHT73PEpvwPLb42OrGNYmhN93nP+X9mvRp5TnfE/9ydimxFGckGmoxFxUnAgCu
	E3SAHAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning:

drivers/pinctrl/pinconf.c:521:20: error: incompatible types in comparison expression (different type sizes)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/pinconf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index e875f21..1516fb0 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -518,7 +518,7 @@ static int pinconf_dbg_config_write(struct file *file,
 	int i;
 
 	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf)-1));
+	buf_size = min(count, (size_t)(sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 	buf[buf_size] = 0;
-- 
1.7.10.4


