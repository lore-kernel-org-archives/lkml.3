Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaJ0Por (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:44:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32420 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJ0PoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:44:24 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-ae-544e6856496a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/4] regulator: max77802: Make regulator_desc array const
Date: Mon, 27 Oct 2014 16:44:13 +0100
Message-id: <1414424654-27277-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
References: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xa7phGX4hBs0tbBZTHz5hs3j9wtDi
	25UOJovLu+awWVxc8YXJgdVj56y77B6bVnWyefRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	h6cf2Qua2Cput6xma2CcxNrFyMkhIWAi0XdmPzuELSZx4d56ti5GLg4hgaWMEvt39LBAOH1M
	Ent2XwfrYBMwlti8fAlYlYhAD6PE+0sn2UASzAKGEj/f/QEbJSzgKXFgym9mEJtFQFVi9coL
	jCA2r4C7xL/zzcwQ6+QkTh6bDDaUU8BDYuGC3WA1QkA1j7c1sk1g5F3AyLCKUTS1NLmgOCk9
	11CvODG3uDQvXS85P3cTIyRwvuxgXHzM6hCjAAejEg/vjmm+IUKsiWXFlbmHGCU4mJVEeA+k
	+YUI8aYkVlalFuXHF5XmpBYfYmTi4JRqYHRcZdr5626dWbqkkO03vof71vBxatW4Bz+L3CDh
	ujjRfPe2a8alPpwyt9c7b2yUrOEoME3J+TTz7sF3ywO7Oi0DO14/q9loZDjJJfNkTkpqfUxf
	9c6k3ikpAluXvmO43fbzL9tK5kyeaZv9WGbN0JJ/3SpyVyB8n8eexXvP8Sl88u92z+nOUWIp
	zkg01GIuKk4EACEVDe/6AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_register() expects array of 'regulator_desc' to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77802.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 61d03e9f8acf..3e57e4f5c721 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -475,7 +475,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.enable_mask	= MAX77802_OPMODE_MASK,				\
 }
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	regulator_77802_desc_16_buck(1),
 	regulator_77802_desc_234_buck(2),
 	regulator_77802_desc_234_buck(3),
-- 
1.9.1

