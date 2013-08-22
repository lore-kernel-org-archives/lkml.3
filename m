Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3HVCBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:01:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29528 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3HVCA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:00:59 -0400
X-AuditID: cbfee691-b7fef6d000002d62-41-521570d70e0e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        "'Simon Horman'" <horms@verge.net.au>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] pinctrl: sh-pfc: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:00:55 +0900
Message-id: <001b01ce9edb$70236f80$506a4e80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e23AKg3btabqsThaqrg2FxtjBiA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zY93rBaJBBv9+mlk0b/3KaHF54SVW
	i4lNd1gspvxZzmRxedccNgdWj9kdM1k97lzbw+bRt2UVo8ecn99YPD5vkgtgjeKySUnNySxL
	LdK3S+DKuDnrH1PBadaK870TGRsYz7F0MXJySAiYSMw4/p0NwhaTuHBvPZgtJLCMUaKpw7SL
	kQOs5tyusC5GLqDwIkaJNT0/WCGcX4wSH15PB2tgE1CT+PLlMDuILSKgJ/HmawuYzSwwjVHi
	+Cs+EFtYwFvi/fQ5YPUsAqoSH8+dBDuCV8BWov/nX0YIW1Dix+R7LBC9WhLrdx5ngrDlJTav
	ecsMcZC6xKO/ujCrbr+YAVUiIrHvxTtGkNskBPaxS2z/9JMJYpeAxLfJh1ggemUlNh1ghvhX
	UuLgihssExjFZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJC4
	m7iD8f4B60OMyUDrJzJLiSbnA+M2ryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2MHlFlD4V/Sm/+0HukYkuOQO56B5suH7Fg7nDraQs/712Z+bO1
	/fJ1JRkTn4/371otfxJQytbV/Le3yCJNrkpvnRO3S2fDgbuNoVmPNCc8P3a58F4Yy0XGdbNr
	l1+fFfkyZ8tJPYOeAxrmkWzBsxUE1wYs4Ylze1Xc0995M7nbrmuReuBlVhclluKMREMt5qLi
	RABYIwDc0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd3rBaJBBi1/jSyat35ltLi88BKr
	xcSmOywWU/4sZ7K4vGsOmwOrx+yOmawed67tYfPo27KK0WPOz28sHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZtyc9Y+p4DRrxfneiYwNjOdYuhg5OCQETCTO
	7QrrYuQEMsUkLtxbz9bFyMUhJLCIUWJNzw9WCOcXo8SH19PZQKrYBNQkvnw5zA5iiwjoSbz5
	2gJmMwtMY5Q4/ooPxBYW8JZ4P30OWD2LgKrEx3MnWUBsXgFbif6ffxkhbEGJH5PvsUD0akms
	33mcCcKWl9i85i0zxHHqEo/+6sKsuv1iBlSJiMS+F+8YJzAKzEIyaRaSSbOQTJqFpGUBI8sq
	RtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOC4fia9g3FVg8UhRgEORiUe3gs7RYKEWBPLiitz
	DzFKcDArifBKa4kGCfGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MOXklcQbGpuYGVkamVkY
	mZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAPjhPZ38yMX1LA/2HXixdL0y8piOR9+
	cJwt2eX1O5hV0kD7YXUC+/GnAX/V99VbMq48Knugy9fAX/3ps663W3p8HCuPG82TzRM3m7TE
	7PVKLuenx+dfSSl9uvPnkXKmMvX+SV+eP2naYWCpJu23svb+ZZcWlsbw8kkX5+iu0tiU4b7M
	eJ6CCIO2EktxRqKhFnNRcSIADmYmMi8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/sh-pfc/core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/core.c b/drivers/pinctrl/sh-pfc/core.c
index 9e66614..738f14f 100644
--- a/drivers/pinctrl/sh-pfc/core.c
+++ b/drivers/pinctrl/sh-pfc/core.c
@@ -539,8 +539,6 @@ static int sh_pfc_remove(struct platform_device *pdev)
 	if (pfc->info->ops && pfc->info->ops->exit)
 		pfc->info->ops->exit(pfc);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.10.4


