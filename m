Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaGHTII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:08:08 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:45828 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932331AbaGHTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:05:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgNAORAvFNXQDwH/2dsb2JhbABZgw6tJQEBAQEBAQUBbgGZWQGBFxd1hAQBBXkQUTkeGYhGAcgmF4V6iUgHFoQtBZp2lAyDRTs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/9] i40e: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 21:05:23 +0200
Message-Id: <1404846329-19235-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404846329-19235-1-git-send-email-fabf@skynet.be>
References: <1404846329-19235-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
index 870ab1e..7c6bf89 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
@@ -417,7 +417,6 @@ static i40e_status i40e_create_lan_hmc_object(struct i40e_hw *hw,
 			default:
 				ret_code = I40E_ERR_INVALID_SD_TYPE;
 				goto exit;
-				break;
 			}
 		}
 	}
@@ -502,7 +501,6 @@ try_type_paged:
 		hw_dbg(hw, "i40e_configure_lan_hmc: Unknown SD type: %d\n",
 			  ret_code);
 		goto configure_lan_hmc_out;
-		break;
 	}
 
 	/* Configure and program the FPM registers so objects can be created */
-- 
1.8.4.5

