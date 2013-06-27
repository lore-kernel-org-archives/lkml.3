Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3F0Xn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:43:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53168 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3F0Xny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:43:54 -0400
X-AuditID: cbfee691-b7fef6d000002d62-5a-51ccce33cab0
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Stanislaw Gruszka'" <sgruszka@redhat.com>,
        "'John W. Linville'" <linville@tuxdriver.com>, cpgs@samsung.com
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable]  iwlegacy: fix rate control regression
Date: Fri, 28 Jun 2013 08:43:46 +0900
Message-id: <002401ce7390$2aebe2b0$80c3a810$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxAFffBYYA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zfV3jc2cCDX5vVLV4eUjTYkkzt8Xl
	XXPYLLb2SFgsnnOGxWLBxkeMDmwe7/ddZfPo27KK0ePK99WMHp83yQWwRHHZpKTmZJalFunb
	JXBl9MzPLtjMW7F3gUQD40buLkZODgkBE4kN23+zQ9hiEhfurWfrYuTiEBJYxihx/+0PRpii
	f/87GCESixgl7l37DVX1l1FiV+9MNpAqNgFdiWPrt7CC2CIC3hKnpvxiBrGZBToYJfqOAsU5
	gBq4JVY3B4GEOQV4JNb96QQrERZwkuja8ZIZpIRFQFXiQnsOSJhXwE7i+uIFzBC2oMSPyfdY
	ICZqSazfeZwJwpaX2LzmLVirhIC6xKO/uhAHTGGU+LzGAqJERGLfi3dg50sIXGKXWPT7AdjD
	LAICEt8mH2KB6JWV2HSAGeJdSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPS
	i0z1ihNzi0vz0vWS83M3MUKic+IOxvsHrA8xJgOtn8gsJZqcD4zuvJJ4Q2MzIwtTE1NjI3NL
	M9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwGl/j89a4x309KDf34YojH5On
	BVcGna5V7F4UVadTkPL7q/v09mT7FRHrvm+7/iu6c+Kb8ocLF0msPmf1WIPx/cn0Ft5Tp3y/
	HMvvfvX/zJYrOz4fS1XhPBq6u+/rDvt0kYNO3yesEup8sCFDvGnWLZ2tJ81VVzJ76hSVC1il
	/FgWViHg5JF7XImlOCPRUIu5qDgRAOYPmTzkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jAV3jc2cCDd42KFq8PKRpsaSZ2+Ly
	rjlsFlt7JCwWzznDYrFg4yNGBzaP9/uusnn0bVnF6HHl+2pGj8+b5AJYohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAVisplCXmlAKFAhKLi5X0
	7TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM3rmZxds5q3Yu0CigXEjdxcjJ4eEgInEv/8djBC2
	mMSFe+vZuhi5OIQEFjFK3Lv2G8r5yyixq3cmG0gVm4CuxLH1W1hBbBEBb4lTU34xg9jMAh2M
	En1HgeIcQA3cEqubg0DCnAI8Euv+dIKVCAs4SXTteMkMUsIioCpxoT0HJMwrYCdxffECZghb
	UOLH5HssEBO1JNbvPM4EYctLbF7zFqxVQkBd4tFfXYgDpjBKfF5jAVEiIrHvxTvGCYxCs5BM
	moVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzj2n0nvYFzVYHGIUYCD
	UYmHtyHxTKAQa2JZcWXuIUYJDmYlEd47C4BCvCmJlVWpRfnxRaU5qcWHGJOB/pzILCWanA9M
	S3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwBglWCxzel21
	7k7W1CLdI1MO+27+KJF197whN+/ea/bzpsuuPtHwanJm46sjLwI/zHtbvX9x8j2J4hnC5ZvF
	bE43/y5hswt6OItX/Udf9gt/Ly8np3mm195kSJ9+ECkr/FznW/l39cMJp07FPtTc/Z7d1OZa
	wXGbSS8OJ7lXvXyuF1l3/12fm44SS3FGoqEWc1FxIgB5fxxgQQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Stanislaw Gruszka <sgruszka@redhat.com>"

commit a8cf0194b7187fb65dfff28a1c5153d442e3836a upstream

Since driver does not use control.rates[0].count, we have never set that
variable. But currently, after rate control API rewrite, this is required
by mac80211. Otherwise legacy rates control does not work and we transmit
always at 1Mbit/s on pre 11n networks.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/net/wireless/iwlegacy/3945-rs.c |    1 +
 drivers/net/wireless/iwlegacy/4965-rs.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c
b/drivers/net/wireless/iwlegacy/3945-rs.c
index d4fd29a..dde7ff0 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -816,6 +816,7 @@ out:
 		rs_sta->last_txrate_idx = idx;
 		info->control.rates[0].idx = rs_sta->last_txrate_idx;
 	}
+	info->control.rates[0].count = 1;
 
 	D_RATE("leave: %d\n", idx);
 }
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c
b/drivers/net/wireless/iwlegacy/4965-rs.c
index 6c7493c..38fb9e1 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2268,7 +2268,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta
*sta, void *il_sta,
 		info->control.rates[0].flags = 0;
 	}
 	info->control.rates[0].idx = rate_idx;
-
+	info->control.rates[0].count = 1;
 }
 
 static void *
-- 
1.7.9.5

