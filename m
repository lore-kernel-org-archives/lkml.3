Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaA1MYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:24:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32551 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaA1MTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:05 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-e5-52e7a0389227
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 05/18] mfd: max14577: Use of_match_ptr() in i2c_driver
Date: Tue, 28 Jan 2014 13:18:29 +0100
Message-id: <1390911522-28209-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4NV2LBc+DDNZNErSY+vAJm8X1L89Z
	LV6/MLQ42/SG3eL+16OMFt+udDBZbHp8jdXi8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4Eem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG7tUv2AuWslVM
	vT6ZpYFxKWsXIweHhICJxJQXKl2MnECmmMSFe+vZuhi5OIQEljJKbGzqZIRw+pgkDn/+wwxS
	xSZgLLF5+RKwKhGB1UwSaxZMZQFJMAv0Mkrc3O0BYgsLuEl8m78crIFFQFXi6Zrz7CA2r4C7
	RO+nRUwQmxUk5kyyAQlzCnhIvLrayARiCwGVnDr+jmUCI+8CRoZVjKKppckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGCGB+HUH49JjVocYBTgYlXh4H3Q/CxJiTSwrrsw9xCjBwawkwps4+3mQEG9K
	YmVValF+fFFpTmrxIUYmDk6pBkahe4/ktz2JU2E9d8Zrx+K1zL/tY40dG1u1XjBNMW1hYvzA
	8Vvfwu6Xj8ORson/lzBGbwhsm+DtNL1Dy/tas+Wfn7GajmeD1vKdO9EYXp52JKn/9aM6v2mr
	DWQfJffHKJq4Mmk91Es8LW1+4FxxhsQajZecn13jnF8d61XpaZodxXS3a0bXXCWW4oxEQy3m
	ouJEAFoYyPEiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of_match_ptr() in assignment of i2c_driver.of_match_table.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mfd/max14577.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 2ac2f2d7cea6..75b37082a3fe 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -224,7 +224,7 @@ static struct i2c_driver max14577_i2c_driver = {
 		.name = "max14577",
 		.owner = THIS_MODULE,
 		.pm = &max14577_pm,
-		.of_match_table = max14577_dt_match,
+		.of_match_table = of_match_ptr(max14577_dt_match),
 	},
 	.probe = max14577_i2c_probe,
 	.remove = max14577_i2c_remove,
-- 
1.7.9.5

