Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbbA1Uc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:32:56 -0500
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:56810 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755793AbbA1Ucw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:32:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:973:988:989:1260:1345:1437:1537:1561:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3867:5007:6261:6642:10004:10848:11026:11658:11914:12043:12438:12517:12519:12683:13311:13357:14095:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: team68_33c9825456e11
X-Filterd-Recvd-Size: 940
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] dvb_net: general cleaning
Date: Wed, 28 Jan 2015 10:05:49 -0800
Message-Id: <cover.1422468185.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more common kernel mechanisms

Joe Perches (3):
  dvb_net: Use vsprintf %pM extension to print Ethernet addresses
  dvb_net: Use standard debugging facilities
  dvb_net: Convert local hex dump to print_hex_dump_debug

 drivers/media/dvb-core/dvb_net.c | 88 ++++++++++++----------------------------
 1 file changed, 26 insertions(+), 62 deletions(-)

-- 
2.1.2

