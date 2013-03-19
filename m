Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab3CSFbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:31:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53946 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3CSFbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:31:38 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-4a-5147f839c5f7
From: Jingoo Han <jg1.han@samsung.com>
To: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce2462$e31b5fa0$a9521ee0$%han@samsung.com>
In-reply-to: <000101ce2462$e31b5fa0$a9521ee0$%han@samsung.com>
Subject: [PATCH v2 2/2] extcon: max8997: add missing const
Date: Tue, 19 Mar 2013 14:31:36 +0900
Message-id: <000201ce2463$06750e60$135f2b20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4kYt9lRWnD2nPSSoCwWKQtUrUYLAAAAhzg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI13LH+6BBn/XsFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MaS2X2Av28lbsPnqHvYGxj7uLkZNDQsBEYtH3JewQtpjEhXvr
	2boYuTiEBJYxSny8/IkNpujC843sEIlFjBLTP1xhhHBmM0n86bzOCFLFJqAm8eXLYbBRIgK6
	Ei+v3mYGsZkF8iSmHNkFZgsJ2Eoc+bASzOYUsJOYuPMsE4gtLGAlsfZjFwuIzSKgKvHp31uw
	zbxA9U0z2lggbEGJH5PvsUDM1JJYv/M4E4QtL7F5zVugmRxAl6pLPPqrC3GCkcS7M9fZIUpE
	JPa9eAd2s4TAPHaJNUd/skHsEpD4NvkQC0SvrMSmA8wQD0tKHFxxg2UCo8QsJJtnIdk8C8nm
	WUhWLGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRElv9OxjvHrA+xJgMtH4is5Rocj4w
	NvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDgj
	5I3hSonsA+wnVCSEc24a3N4wVW7uryj3HTsEj28uELdmNWROdb+87q9I8vcM958BNxbVXXx/
	sjPnU9bdqIb4g8891OXLbq81Ciq8OtWsdoXj0t2izy8GLruxPCFIPFShSlRo/Ro5hSNTi/ba
	/uO8sebWtm/TJtgL7/zYuuiPDn9fxvJzjLlKLMUZiYZazEXFiQBe1TL5wwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK7lD/dAg2cmFpd3zWFzYPT4vEku
	gDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
	kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFjWssl9oK9vBW7j95hb2Ds
	4+5i5OSQEDCRuPB8IzuELSZx4d56ti5GLg4hgUWMEtM/XGGEcGYzSfzpvM4IUsUmoCbx5cth
	sA4RAV2Jl1dvM4PYzAJ5ElOO7AKzhQRsJY58WAlmcwrYSUzceZYJxBYWsJJY+7GLBcRmEVCV
	+PTvLRuIzQtU3zSjjQXCFpT4MfkeC8RMLYn1O48zQdjyEpvXvAWayQF0qbrEo7+6ECcYSbw7
	c50dokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcNw+k9rBuLLB4hCjAAejEg/viWD3QCHWxLLiytxDjBIczEoivMH+QCHelMTKqtSi/Pii
	0pzU4kOMyUCPTmSWEk3OB6aUvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphak
	FsFsYeLglGpgZFom4bEqOb3XcYdVQoCCp2WdkcCiewvd7SwPB8y8GcjgI73jVsXvjyXZOv47
	2nqWGObXpoqU7QrcFjI7pPhIqsTHPZMzN7tnNt362jzLVU7ctNHwjXt1h9jpfVkzbisyCBw5
	FFuh9WHW1uO+FQac+rllS/7wsTdP+Dm/4nSvyftPSXnTmR4qsRRnJBpqMRcVJwIAp5q3Sx8D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: static const char * array should probably be static const char * const
  #163: FILE: drivers/extcon/extcon-max8997.c:163:
  +static const char *max8997_extcon_cable[] = {

Also, const is added to variable 'supported_cable' to prevent
build warning as below:

  drivers/extcon/extcon-max8997.c: In function 'max8997_muic_probe':
  drivers/extcon/extcon-max8997.c:708:30: warning: assignment discards 'const' qualifier from pointer target type [enabled by
default]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Added const to variable 'supported_cable'

 drivers/extcon/extcon-max8997.c |    2 +-
 include/linux/extcon.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 20772ad..b82a591 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -160,7 +160,7 @@ enum {
 	_EXTCON_CABLE_NUM,
 };
 
-static const char *max8997_extcon_cable[] = {
+static const char * const max8997_extcon_cable[] = {
 	[EXTCON_CABLE_USB]			= "USB",
 	[EXTCON_CABLE_USB_HOST]			= "USB-Host",
 	[EXTCON_CABLE_TA]			= "TA",
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index fcb51c8..741a491 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -113,7 +113,7 @@ struct extcon_cable;
 struct extcon_dev {
 	/* --- Optional user initializing data --- */
 	const char	*name;
-	const char **supported_cable;
+	const char * const *supported_cable;
 	const u32	*mutually_exclusive;
 
 	/* --- Optional callbacks to override class functions --- */
-- 
1.7.2.5


