Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617AbaHZNCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:02:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8306 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbaHZNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:02:45 -0400
X-AuditID: cbfee68d-f79c46d000000b84-2e-53fc85736feb
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 18/18] backlight: omap1: add blank line after declarations
Date: Tue, 26 Aug 2014 22:02:43 +0900
Message-id: <00bc01cfc12e$066bd3e0$13437ba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAANPzw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zA93i1j/BBtsOmVsc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBknd15j
	LNjNWtGzcx5LA+MFli5GTg4JAROJs0+vMUPYYhIX7q1n62Lk4hASWMYo0bRqBStM0dy+Q8wQ
	iemMEj1TPzOCJIQEfjNKbOp0BbHZBNQkvnw5zA5iiwgoSGzufQbWzCyQK/F75kqoeluJ+dsg
	hnIK2EksPXwOrF5YwEtidtMfJhCbRUBVYu3/hWDX8QLV35+xEsoWlPgx+R4LxEwtifU7jzNB
	2PISm9e8BTqOA+hQdYlHf3UhTjCS+PfvCdQJIhL7XrxjBLlfQuAYu8SuBaegdglIfJt8iAWi
	V1Zi0wFoQEhKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kqFecmFtcmpeu
	l5yfu4kREpW9OxhvH7A+xCjAwajEw3sj/newEGtiWXFl7iFGU6CLJjJLiSbnA2M/ryTe0NjM
	yMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxqU25w0eii0/5H1P
	mU1IZaaTiHvIiWTRmkidvzYB279/Od+97XIxt+jRCw97at7vOLC4/mXchdsTubRrJBYxTfrw
	qNLKd8+vz6UNc3Rt8lOrG9TMPbkEt5z+ZXn2fLxJ4MGV7r+yzhk4Gn9nSnpvfbIjZ/v8vktL
	39lnVnY6poT/z9zpEHpTSomlOCPRUIu5qDgRAIF0U5jFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd3i1j/BBrPmmFgc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZJ3deYyzYzVrRs3MeSwPjBZYuRk4OCQETibl9h5ghbDGJC/fW
	s3UxcnEICUxnlOiZ+pkRJCEk8JtRYlOnK4jNJqAm8eXLYXYQW0RAQWJz7zNWEJtZIFfi98yV
	UPW2EvO3rQCLcwrYSSw9fA6sXljAS2J20x8mEJtFQFVi7f+FYEfwAtXfn7ESyhaU+DH5HgvE
	TC2J9TuPM0HY8hKb17wFOpQD6FB1iUd/dSFOMJL49+8J1AkiEvtevGOcwCg0C8mkWUgmzUIy
	aRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmP+mdQOxpUNFocYBTgYlXh4b8T/
	DhZiTSwrrsw9xCjBwawkwvsj6U+wEG9KYmVValF+fFFpTmrxIUZToEcnMkuJJucD01FeSbyh
	sYmZkaWRmYWRibm5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbGiC/ae7c5C//8UrlOrMqG
	TdKl03jO6vwfzG692XfSJQ+1Tz5X8Nqo9vpRg50Ol031xX1dNyxN7WZcxGexRU/QvcLxnm7r
	KQH5lgtP/e4vruTs2mdTuum34WUO3zkTN8QF5j/bPS99+Vz96c+vmy56WLIoRsTSeZZhS+a8
	pS0tfim/9lYfue+mxFKckWioxVxUnAgAyrNQbQ8DAAA=
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
 drivers/video/backlight/omap1_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index a0dcd88ac74f..546d94df21d5 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -120,6 +120,7 @@ static int omapbl_update_status(struct backlight_device *dev)
 static int omapbl_get_intensity(struct backlight_device *dev)
 {
 	struct omap_backlight *bl = bl_get_data(dev);
+
 	return bl->current_intensity;
 }
 
-- 
2.0.0


