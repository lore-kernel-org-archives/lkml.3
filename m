Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaDYBvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:51:13 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:42915 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750820AbaDYBvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:51:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:960:973:988:989:1260:1345:1534:1539:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3867:4605:5007:6261:6642:10004:10026:10848:11026:11657:11658:11914:12043:12517:12519:12679:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bun05_612e8f4b7d904
X-Filterd-Recvd-Size: 1441
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 0/5] treewide: Convert logging message misuses of /n to \n
Date: Thu, 24 Apr 2014 18:50:58 -0700
Message-Id: <cover.1398390579.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (5):
  qlge: Convert /n to \n
  iwlegacy: Convert /n to \n
  staging: rtl<foo>: Convert /n to \n
  appledisplay: Convert /n to \n
  sound: tlv320aic31xx: Convert /n to \n

 drivers/net/ethernet/qlogic/qlge/qlge_main.c  | 2 +-
 drivers/net/wireless/iwlegacy/3945.c          | 2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c      | 2 +-
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c | 2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   | 2 +-
 drivers/staging/rtl8723au/hal/usb_ops_linux.c | 4 ++--
 drivers/staging/rtl8723au/os_dep/usb_intf.c   | 2 +-
 drivers/usb/misc/appledisplay.c               | 2 +-
 sound/soc/codecs/tlv320aic31xx.c              | 2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

