Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaKDAZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:25:55 -0500
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:34619 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750719AbaKDAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:25:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:988:989:1260:1345:1359:1534:1540:1567:1711:1714:1730:1747:1777:1792:1978:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:4605:5007:6114:6261:6642:8829:10004:10848:11658:11914:12043:12517:12519:12679:13095:13311:13357:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: corn44_6d75d02f89940
X-Filterd-Recvd-Size: 1636
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/2] staging: ft1000: generic neatening
Date: Mon,  3 Nov 2014 16:25:42 -0800
Message-Id: <cover.1415060503.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141104000656.GA17825@kroah.com>
References: <20141104000656.GA17825@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  staging: ft1000: Whitespace neatening
  ASoC: staging: ft1000: Logging message neatening

 drivers/staging/ft1000/ft1000-pcmcia/boot.h        |   34 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   30 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |   50 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |  208 ++--
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |  894 +++++++--------
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   | 1198 ++++++++++----------
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  394 +++----
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |  436 ++++---
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |   60 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   97 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    4 +-
 11 files changed, 1635 insertions(+), 1770 deletions(-)

-- 
2.1.2

