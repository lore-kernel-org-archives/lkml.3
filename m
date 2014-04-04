Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaDDWQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:16:12 -0400
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:52290 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752458AbaDDWQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:16:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:960:988:989:1260:1345:1437:1534:1538:1566:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3867:4823:5007:6261:6642:10004:10026:10848:11658:11914:12043:12291:12517:12519:12679:12683:13311:13357:14095:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cord68_6fdf33b1f9333
X-Filterd-Recvd-Size: 1060
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ftdi-elan: neatening
Date: Fri,  4 Apr 2014 15:16:02 -0700
Message-Id: <cover.1396649386.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found when looking for invalid vsprintf %<foo> types,
with some other neatenings done.

Joe Perches (5):
  usb: ftdi-elan: Fix format fragments
  usb: ftdi-elan: Convert leading spaces to tabs
  usb: ftdi-elan: Coalesce formats
  usb: ftdi-elan: Coalesce string fragment
  usb: ftdi-elan: Use pr_<level>

 drivers/usb/misc/ftdi-elan.c | 4878 +++++++++++++++++++++---------------------
 1 file changed, 2419 insertions(+), 2459 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

