Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbaC0LIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:08:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46856 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbaC0LIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:08:51 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-1e-533406c28f93
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] clk: Fix minor errors in of_clk_init() function comments
Date: Thu, 27 Mar 2014 12:08:36 +0100
Message-id: <1395918516-23822-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jQd1DbCbBBpNPCFlsenyN1eLyrjls
	Fk8nXGSzOPymndWBxePOtT1sHpuX1Hv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxtYtSxkL
	XnJUTOx9xd7A2MzexcjBISFgInHss0QXIyeQKSZx4d56NhBbSGA6o8ST/WEQdgeTROsSbhCb
	TcBQovdoHyOILSIgKfHg83QWEJtZoFTixKmHzCC2sICnxIUJEDaLgKrEvR9vwep5BdwkWv72
	skGsVZCYM8lmAiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBXn8mvYNxVYPFIUYB
	DkYlHt4d942ChVgTy4orcw8xSnAwK4nw9v81DhbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DV
	OlBIID2xJDU7NbUgtQgmy8TBKdXAuLWK96eVvOZJ8QdHkxQ2bLGXSPScXty60WgHq9uaoslb
	ejZNN9+YtfXfj213HHwfHNljbiYj/49lYprQ90PekZwni3VTJdzKjGKOB9VcW+K56XBif0IA
	78/5DwRs1NiE1jsKVbg26B3Vfqbv4XNt4Wb3Q09nSa78eXK1PNP6IkfbQ1N4pH96KrEUZyQa
	ajEXFScCAJepmx32AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/clk/clk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c859adf..29dc1e7 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2575,7 +2575,7 @@ static int parent_ready(struct device_node *np)
  * @matches: array of compatible values and init functions for providers.
  *
  * This function scans the device tree for matching clock providers
- * and calls their initialization functions. It also do it by trying
+ * and calls their initialization functions. It also does it by trying
  * to follow the dependencies.
  */
 void __init of_clk_init(const struct of_device_id *matches)
@@ -2612,7 +2612,7 @@ void __init of_clk_init(const struct of_device_id *matches)
 		}
 
 		/*
-		 * We didn't managed to initialize any of the
+		 * We didn't manage to initialize any of the
 		 * remaining providers during the last loop, so now we
 		 * initialize all the remaining ones unconditionally
 		 * in case the clock parent was not mandatory
-- 
1.7.9.5

