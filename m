Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbaHZNAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:00:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52354 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaHZNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:00:29 -0400
X-AuditID: cbfee691-f79546d0000011a1-73-53fc84ec7e5b
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 11/18] backlight: lp855x: add blank line after declarations
Date: Tue, 26 Aug 2014 22:00:28 +0900
Message-id: <00b501cfc12d$b5a1c280$20e54780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAIRNg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA903LX+CDV49ELM4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDKeTz3M
	WrCaveLGkxdsDYxdbF2MHBwSAiYSN//rdTFyApliEhfurQcKc3EICSxjlNjU94MFImEicWnf
	RkaIxCJGiU/Hm5ggnN+MEo9bPjKCVLEJqEl8+XKYHcQWEVCQ2Nz7jBXEZhbIlfg9cyVYjZCA
	rcT8bSvA4pwCdhJLD59jB7lCWMBbYtIiQxCTRUBVYsd3VZAKXqDqV+39zBC2oMSPyfdYICZq
	SazfeZwJwpaX2LzmLTPEL+oSj/7qQhxgJLFwWQ9UuYjEvhfvwM6XEDjGLrH/2S2wa1gEBCS+
	TT7EAtErK7HpADPEu5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ6hUn
	5haX5qXrJefnbmKEROTEHYz3D1gfYhTgYFTi4b0R/ztYiDWxrLgy9xCjKdBFE5mlRJPzgXGf
	VxJvaGxmZGFqYmpsZG5ppiTOqyP9M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD48ncu5mR
	SlIXNu05/KvmV7qhUt8D78N675/yX4z/1B8Rsilh0pcFDW9mST5dr5vSy8dx8NHNlL/Zf0XW
	s1qG8GxKO3/kQPSRhU1Nerd03r39rfpty/6ngQcNHZLuyjQYR/TM2FbutlkxYKbZnPMvNuU9
	uv4x0ynNT0FO+4pS8NZ1yjYfzgbU7lNiKc5INNRiLipOBADhYRWOwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd03LX+CDR4dE7Y4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgznk89zFqwmr3ixpMXbA2MXWxdjJwcEgImEpf2bWSEsMUkLtxb
	DxTn4hASWMQo8el4ExOE85tR4nHLR7AqNgE1iS9fDrOD2CICChKbe5+xgtjMArkSv2euBKsR
	ErCVmL9tBVicU8BOYunhc0D1HBzCAt4SkxYZgpgsAqoSO76rglTwAlW/au9nhrAFJX5MvscC
	MVFLYv3O40wQtrzE5jVvmUFaJQTUJR791YU4wEhi4bIeqHIRiX0v3jFOYBSahWTSLCSTZiGZ
	NAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwRH/THoH46oGi0OMAhyMSjy8N+J/
	BwuxJpYVV+YeYpTgYFYS4f2R9CdYiDclsbIqtSg/vqg0J7X4EKMp0J8TmaVEk/OBySivJN7Q
	2MTMyNLIzMLIxNxcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVAOjoILdrRsKf1RP3zA4+4ft
	R5WshntWdM0uQXvJQ4zvIo1MnJTmbfoRFbpa5b/nu+MTKtZYG9/4LWV8ImcvgxNDu9DOL1aH
	V6V2PfhzSyVlxR+xMLUdIsaVxkm8aWw21ieEdi9Pe8LxfuUx5xqPXHfHf7HPrxrxm+dJmPcZ
	Hn+YpKHxQ1j5OY8SS3FGoqEWc1FxIgB6Z2Q8DgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lp855x_bl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index dcdd5443efcf..25fb8e3d75b1 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -268,6 +268,7 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
 
 	} else if (lp->mode == REGISTER_BASED) {
 		u8 val = bl->props.brightness;
+
 		lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
 	}
 
@@ -308,6 +309,7 @@ static ssize_t lp855x_get_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct lp855x *lp = dev_get_drvdata(dev);
+
 	return scnprintf(buf, PAGE_SIZE, "%s\n", lp->chipname);
 }
 
-- 
2.0.0


