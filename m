Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3IIFfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:35:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48369 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3IIFfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:35:14 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-a0-522d5e11e9d6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Xianglong Du'" <Xianglong.Du@csr.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: sirfsoc: Remove casting the return value which is a void
 pointer
Date: Mon, 09 Sep 2013 14:35:12 +0900
Message-id: <005301cead1e$5b1fd500$115f7f00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6tHlVP/meC2C5RRTOEl4Lc/ZvSVw==
Content-language: ko
x-cr-hashedpuzzle: BmvW Evu7 HOHZ Kk// Uoac WYWR W3U8 ZX5+ iPQQ jN8k jVlO rHz/
 t2WH 2BQK 4/xl
 AANLvA==;6;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtADsAeABpAGEAbgBnAGwAbwBuAGcALgBkAHUAQABjAHMAcgAuAGMAbwBtAA==;Sosha1_v1;7;{87049FEF-2FAB-4E06-9020-976315C0B21A};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 09 Sep 2013 05:35:03
 GMT;WwBQAEEAVABDAEgAXQAgAHIAdABjADoAIABzAGkAcgBmAHMAbwBjADoAIABSAGUAbQBvAHYAZQAgAGMAYQBzAHQAaQBuAGcAIAB0AGgAZQAgAHIAZQB0AHUAcgBuACAAdgBhAGwAdQBlACAAdwBoAGkAYwBoACAAaQBzACAAYQAgAHYAbwBpAGQAIABwAG8AaQBuAHQAZQByAA==
x-cr-puzzleid: {87049FEF-2FAB-4E06-9020-976315C0B21A}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zI13BON0gg54nHBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0WL12mtMDmweu3bOYfXYM/Ekm8eJGb9ZPPq2rGL0mD7vJ5PH501y
	AWxRXDYpqTmZZalF+nYJXBkr/xxhL/jOX/FtT2YDYxdvFyMnh4SAicS0/SsZIWwxiQv31rOB
	2EICyxgl3r7JgKn5vukoUJwLKD6dUaJx/VR2iKJfjBKTp5eB2GwCahJfvhwGinNwiAjoS7S1
	aIDUMwtsY5ToP9THAlIjLBAhMXffdGYQm0VAVWLqpx1gy3gFbCU+PV3ECmELSvyYfA+snllA
	S2L9zuNMELa8xOY1b5lB5ksIqEs8+qsLEhYR0JP42NMEVSIise/FO0aQvRICJ9gk7p+8yQrx
	gKnEg08nmSASH9klNu6aBnWEgMS3yYdYIIbKSmw6wAxRLylxcMUNlgmMErOQnDQLyUmzkJw0
	C8nuBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFCYrd3B+PtA9aHGJOB1k9klhJNzgfG
	fl5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGKd+
	mhs6/d+Orxz8Yvap98O2SK5b6J8YZ+Z2Ym9mjayb/2KDBs1vmx7UKCfpPm17a8pmPS+mr/vF
	7QfTswKWfBZzeR++UHZ3luqlH9xeFSumVn8Qf3oyNXlLxSM21W31naFXrY+uUmx65u1xOHnv
	57csXvueZr1u3aK354v/n2gJoTctKcpLfiixFGckGmoxFxUnAgC1QyYj8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV3BON0gg75tLBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0WL12mtMDmweu3bOYfXYM/Ekm8eJGb9ZPPq2rGL0mD7vJ5PH501y
	AWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzVv45wl7wnb/i257MBsYu
	3i5GTg4JAROJ75uOskHYYhIX7q0Hsrk4hASmM0o0rp/KDpIQEvjFKDF5ehmIzSagJvHly2Gg
	OAeHiIC+RFuLBkg9s8A2Ron+Q30sIDXCAhESc/dNZwaxWQRUJaZ+2gG2gFfAVuLT00WsELag
	xI/J98DqmQW0JNbvPM4EYctLbF7zlhlkvoSAusSjv7ogYREBPYmPPU1QJSIS+168YwTZKyFw
	gk3i/smbrBAPmEo8+HSSaQKj0CwkK2YhWTELyYpZSGYtYGRZxSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iRGcGp5J7WBc2WBxiFGAg1GJh1fiv06QEGtiWXFl7iFGCQ5mJRHe88+BQrwpiZVV
	qUX58UWlOanFhxiTgSEwkVlKNDkfmLbySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliS
	mp2aWpBaBLOFiYNTqoExTF26xq2l42c415cpPMuqfs/gNHKW19r2bbqMWscBLxfH5M+3+Ixi
	Knw+xVzu9zHVsxN9GbBNQefgrmML8z4JiCQ2PnDUfFFmcfrgS5Y/kR46TZt/nqq8IGC/Uj12
	89m/C109Hn+YwXeZRWF9/jTN8D0x+oIvWy//3Wx/fl9i0wnZpgyF1DQlluKMREMt5qLiRACT
	CbUoUQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sirfsoc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-sirfsoc.c b/drivers/rtc/rtc-sirfsoc.c
index aa7ed4b..cbda8e4 100644
--- a/drivers/rtc/rtc-sirfsoc.c
+++ b/drivers/rtc/rtc-sirfsoc.c
@@ -58,7 +58,7 @@ static int sirfsoc_rtc_read_alarm(struct device *dev,
 	unsigned long rtc_alarm, rtc_count;
 	struct sirfsoc_rtc_drv *rtcdrv;
 
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	local_irq_disable();
 
@@ -93,7 +93,7 @@ static int sirfsoc_rtc_set_alarm(struct device *dev,
 {
 	unsigned long rtc_status_reg, rtc_alarm;
 	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	if (alrm->enabled) {
 		rtc_tm_to_time(&(alrm->time), &rtc_alarm);
@@ -156,7 +156,7 @@ static int sirfsoc_rtc_read_time(struct device *dev,
 {
 	unsigned long tmp_rtc = 0;
 	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 	/*
 	 * This patch is taken from WinCE - Need to validate this for
 	 * correctness. To work around sirfsoc RTC counter double sync logic
@@ -177,7 +177,7 @@ static int sirfsoc_rtc_set_time(struct device *dev,
 {
 	unsigned long rtc_time;
 	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	rtc_tm_to_time(tm, &rtc_time);
 
@@ -372,7 +372,7 @@ static int sirfsoc_rtc_thaw(struct device *dev)
 {
 	u32 tmp;
 	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	/*
 	 * if resume from snapshot and the rtc power is losed,
-- 
1.7.10.4


