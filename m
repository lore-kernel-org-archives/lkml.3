Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbaKTXsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:48:13 -0500
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:60867 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756647AbaKTXsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:48:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3350:3622:3865:3867:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4659:5007:6261:7809:7875:9010:9012:9025:10004:10400:10848:11232:11257:11658:11914:12043:12517:12519:12740:13069:13072:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: use35_2a3f9d71bfc1f
X-Filterd-Recvd-Size: 1637
Message-ID: <1416527288.6651.27.camel@perches.com>
Subject: Is the list moderated or not?
From: Joe Perches <joe@perches.com>
To: hpdd-discuss-owner@ml01.01.org
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 20 Nov 2014 15:48:08 -0800
In-Reply-To: <mailman.31138.1416527032.9748.hpdd-discuss@lists.01.org>
References: <mailman.31138.1416527032.9748.hpdd-discuss@lists.01.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 15:43 -0800, hpdd-discuss-owner@lists.01.org
wrote:
> You must be a subscriber to post to this list. Please make sure you
> are sending from a subscribed email address. 

The linux-kernel MAINTAINERS file has this as a moderated list.
If it's not moderated, this entry should be changed to subscriber-only.

STAGING - LUSTRE PARALLEL FILESYSTEM
M:	Oleg Drokin <oleg.drokin@intel.com>
M:	Andreas Dilger <andreas.dilger@intel.com>
L:	HPDD-discuss@lists.01.org (moderated for non-subscribers)
W:	http://lustre.opensfs.org/
S:	Maintained
F:	drivers/staging/lustre

If it's really subscriber only, please change the L: line to:

L:	HPDD-discuss@lists.01.org (subscribers-only)


