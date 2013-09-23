Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3IWJof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:44:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16568 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3IWJoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:44:34 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-d4-52400d803b72
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 06/15] rtc: rtc-ds1307: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:44:32 +0900
Message-id: <002201ceb841$818c8ca0$84a5a5e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAANIKQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zY90GXocgg555GhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlTH9+ha1gJXvF1+Vf2BoY+9i6GDk5JARMJJa/+sUMYYtJXLi3HijOxSEksIxR4v3d
	Z+xdjBxgRe8ua0HEpzNK7DjXwQrSICTwi1FiQXc+iM0moCbx5cthsHoRAX2JthYNkHpmgV5G
	iTO9u9kh6m0lJk77ygRicwrYSaz5vIwJpF4YyD6wowAkzCKgKvHt4ntWkDAvUPnFB5YgYV4B
	QYkfk++xgNjMAloSm7c1sULY8hKb17xlhrhSXeLRX12QsIiAkcSKOb/YIEpEJPa9eMcIco2E
	wD12iUmrD7FDrBKQ+Db5EAtEr6zEpgPQUJCUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopR
	NLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJEb7dzDePWB9iDEZaP1EZinR5HxgjOeVxBsamxlZ
	mJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXG7OW9b0/z6GWtC
	JrjlTrqxmnmV9uvfdoqJM4+0l89f8/9gnXrpHUkhDjEJfs+du5uuvZrg1LU05GyAdOu7C4+3
	hPJncG5b8Z3BvanCZqvAl9WsoROmvnoo9ab0YvQzlqQyWcXatq0BPvzR29xPX93runmu5Qme
	0zv7T4XPPlPRnNXx4xrzHmMlluKMREMt5qLiRAA3PEEF5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd0GXocgg30nVCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJj+/ApbwUr2iq/Lv7A1MPaxdTFycEgImEi8
	u6zVxcgJZIpJXLi3HijMxSEkMJ1RYse5DlaQhJDAL0aJBd35IDabgJrEly+H2UF6RQT0Jdpa
	NEDqmQV6GSXO9O5mh6i3lZg47SsTiM0pYCex5vMyJpB6YSD7wI4CkDCLgKrEt4vvWUHCvEDl
	Fx9YgoR5BQQlfky+xwJiMwtoSWze1sQKYctLbF7zlhniYnWJR391QcIiAkYSK+b8YoMoEZHY
	9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcAJ5J
	7WBc2WBxiFGAg1GJhzci0T5IiDWxrLgy9xCjBAezkgivH6tDkBBvSmJlVWpRfnxRaU5q8SHG
	ZKA/JzJLiSbnA5NTXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwpsy6ai4dza7uV3fOwol31mqWffm9dZM5Ipp78yqMt08Q0Vr7eoFug52h6GrGUhfN98G9
	ShYHbHlX15SJBbxzFckv2fdq7uw/5zIjRHx/PHn/OjsqROv9uYceDy5dWrpF5TXHAm3GgM/N
	vCa3T85lco3lCufOrH9ayp9R3fs/3253gtStZ01KLMUZiYZazEXFiQCiq9R9RAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1307.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index e8ac439..bd94920 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -672,7 +672,7 @@ static int ds1307_probe(struct i2c_client *client,
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			want_irq = false;
 	unsigned char		*buf;
-	struct ds1307_platform_data *pdata = client->dev.platform_data;
+	struct ds1307_platform_data *pdata = dev_get_platdata(&client->dev);
 	static const int	bbsqi_bitpos[] = {
 		[ds_1337] = 0,
 		[ds_1339] = DS1339_BIT_BBSQI,
-- 
1.7.10.4


