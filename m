Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaBGIJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:09:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16745 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaBGIJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:09:22 -0500
X-AuditID: cbfee68f-b7f156d00000276c-23-52f494b15b27
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>,
        "'Anirudh Ghayal'" <aghayal@codeaurora.org>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 07/10] rtc: rtc-pm8xxx: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:09:20 +0900
Message-id: <001001cf23db$e7bee0d0$b73ca270$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAP2cA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zI92NU74EGWw7y2Ox5OJVdosHq3Yx
	WsxZv4bN4vLCS6wWl3fNYbPY39nBaPHjTDeLA7vH5b5eJo89E0+yeZyY8ZvFo2/LKkaP6fN+
	Mnl83iQXwBbFZZOSmpNZllqkb5fAlfFo9iWWghdsFRManzI1MF5l7WLk5JAQMJG49XsnC4Qt
	JnHh3nq2LkYuDiGBZYwSM5+vYoQpmrprEzNEYhGjxL45E1ghnF+MEjd+b2cDqWITUJP48uUw
	excjB4eIgL5EW4sGSA2zwGNGick9vewgNUICthK/Pi8BW80pYCex6MRZMFtYwF1izpMeMJtF
	QFWi4/JLsM28QPXHj5xihrAFJX5Mvgd2KrOAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcXJCwi
	YCTx8vYbNogSEYl9L94xgtwjIfCXXWLW773MELsEJL5NPsQC0SsrsekAM8TDkhIHV9xgmcAo
	MQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoREcv8OxrsHrA8x
	JgOtn8gsJZqcD0wEeSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qB0bu70anfUXljdJpKrkYae/+JUuZjaz+bb71geS3gU8XEBeHHaicuXs7yc4V1
	sa7BE28Ro4Tb3H6SGb467o8e74traNm47M0Rk9//LRZ8XWF25PWR6tJl93ym8Fxf7CmWs3bR
	isRv9b4fjpdZqc+SabibxuvjViGqtSZD5odJsJy0V3z7AvubSizFGYmGWsxFxYkAfKY9NfoC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd2NU74EGRw/xWGx5OJVdosHq3Yx
	WsxZv4bN4vLCS6wWl3fNYbPY39nBaPHjTDeLA7vH5b5eJo89E0+yeZyY8ZvFo2/LKkaP6fN+
	Mnl83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj0exLLAUv2Com
	ND5lamC8ytrFyMkhIWAiMXXXJmYIW0ziwr31bF2MXBxCAosYJfbNmcAK4fxilLjxezsbSBWb
	gJrEly+H2bsYOThEBPQl2lo0QGqYBR4zSkzu6WUHqRESsJX49XkJ2AZOATuJRSfOgtnCAu4S
	c570gNksAqoSHZdfMoLYvED1x4+cYoawBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8heCQF1
	iUd/dUHCIgJGEi9vv2GDKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRnCaeSe9gXNVgcYhRgINRiYf3xNLPQUKsiWXFlbmHGCU4mJVEeH82
	fAkS4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgCssriTc0NjEzsjQyszAyMTcnTVhJnPdg
	q3WgkEB6YklqdmpqQWoRzBYmDk6pBkapkPcFXDeTpdSCnRcuXXq6/qXo76TvV5X1RH4fdvH7
	9/vPvrnVWsKuby785kt9py4RGKZzYf1ezeXCystXml3llGl4rqy0J3FKTfjaKpXrTG+vXxbc
	fVvPLLCl8EXXefO1x+IcCz1i0uZZTX/3hWPiX52OxhUFySlNDwSeGd5oWX7R5uF8mVglluKM
	REMt5qLiRACrNwC7VwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pm8xxx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 03f8f75..bd76ffe 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -396,10 +396,8 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		rtc_write_enable = pdata->rtc_write_enable;
 
 	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
-	if (rtc_dd == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate memory!\n");
+	if (rtc_dd == NULL)
 		return -ENOMEM;
-	}
 
 	/* Initialise spinlock to protect RTC control register */
 	spin_lock_init(&rtc_dd->ctrl_reg_lock);
-- 
1.7.10.4


