Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbaCQMrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:47:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20499 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206AbaCQMn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:43:58 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-6e-5326ee0cdbd1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 4/4] max17042_battery: Change battery name instead of
 static name according to device type
Date: Mon, 17 Mar 2014 21:43:47 +0900
Message-id: <1395060227-23378-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
References: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkQJfnnVqwwY8N5hbXvzxntZj05D2z
	xcSVk5ktzja9Ybe4vGsOm8XtxhVsDmweO2fdZffYvELLo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDI+bX/GVrCCo2LO+qvsDYw97F2MnBwSAiYSz/fuZIKwxSQu3FvP1sXIxSEksJRRYsqv
	PUwwRTsOz4ZKTGeUWDXjBTOE08gkserpdTaQKjYBLYn9L26A2SICuhI3ey6DrWAWqJXYd62J
	FcQWFiiQaLz9ESzOIqAq0dR3E2wDr4CrxPtPxxghtslJfNjzCKyGU8BN4vLOacwgthBQzeqn
	i9lBFksItLNLfDj8kw1ikIDEt8mHWLoYOYASshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5IL
	ipPSiwz1ihNzi0vz0vWS83M3MQJD+vS/Z707GG8fsD7EmAw0biKzlGhyPjAm8kriDY3NjCxM
	TUyNjcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMUvpY/TJuzE+P4zY
	+AobO849a3/eW7zvdIfjV9fWrV96fXecu2HNPmuFtODxt1N81fSTSycv9bfc4TS/uqtZmvnb
	qd83tG/OiMt7ve79iUV5GtdOffn4qmzTn5euhkyTCvVOzdtwX/TcgX+eWbnyPAJF3DfPzhAN
	3sfDfz63/k8ob9x0t6iwm0osxRmJhlrMRcWJACCXFWZ/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jQV2ed2rBBg1zDCyuf3nOajHpyXtm
	i4krJzNbnG16w25xedccNovbjSvYHNg8ds66y+6xeYWWR9+WVYwenzfJBbBENTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmfNr+jK1gBUfFnPVX2RsYe9i7GDk5JARMJHYc
	ns0GYYtJXLi3Hsjm4hASmM4osWrGC2YIp5FJYtXT62BVbAJaEvtf3ACzRQR0JW72XAabxCxQ
	K7HvWhMriC0sUCDRePsjWJxFQFWiqe8mE4jNK+Aq8f7TMUaIbXISH/Y8AqvhFHCTuLxzGjOI
	LQRUs/rpYvYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRHzDPpHYyrGiwOMQpw
	MCrx8E5QVgsWYk0sK67MPcQowcGsJMKr9RYoxJuSWFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnA
	aM4riTc0NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBka/dY+UYt6e
	39vly8K3LPrCn9pQnTOea44WH2F/9PGgcenfRT1HzsU9m/AqU7oxa3JiosLJp3Xhvn/kGmaF
	Mi5beTLmS8Of5othboamQb+4XOvY17iw/Ajzfvh1XdZvP9bMSP/WNXO9De0z+Q7Uu+9cKDd5
	7wZ/s+KSmJVBrJu/uPbsY/wvP02JpTgj0VCLuag4EQCXvHWf3AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use device name to make power_supply path according to device type:

[Before]
In case of max17042/max17047/max17050,
- /sys/class/power_supply/max170xx_battery

[After]
In case of max17042,
- /sys/class/power_supply/max17042
In case of max17047,
- /sys/class/power_supply/max17047
In case of max17050,
- /sys/class/power_supply/max17050

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/power/max17042_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 66da691..cba6def 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -707,7 +707,7 @@ static int max17042_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	chip->battery.name		= "max170xx_battery";
+	chip->battery.name		= client->name;
 	chip->battery.type		= POWER_SUPPLY_TYPE_BATTERY;
 	chip->battery.get_property	= max17042_get_property;
 	chip->battery.properties	= max17042_battery_props;
-- 
1.8.0

