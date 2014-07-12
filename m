Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaGLSNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:13:34 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:13940 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbaGLSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:11:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMJAJB5wVNXQ56W/2dsb2JhbABZgw6tMgEBAQEBAQUBbpt/AYEQF3WEBAEFViMQUTkeGYhGAbUIkg0XhXuJUAcWhC0Fmw6UHYNGOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: [PATCH V2 3/9] i40e: remove unnecessary break after goto
Date: Sat, 12 Jul 2014 20:09:42 +0200
Message-Id: <1405188597-2815-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405188597-2815-1-git-send-email-fabf@skynet.be>
References: <1405188597-2815-1-git-send-email-fabf@skynet.be>
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
1.9.1

