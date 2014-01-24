Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaAXFon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:44:43 -0500
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:51472 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751226AbaAXFok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:44:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3876:3877:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4659:5007:6114:6642:7652:7809:7875:7901:9012:9025:10004:10049:10400:10848:11232:11257:11658:11914:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: veil74_287ec1db04730
X-Filterd-Recvd-Size: 1662
Message-ID: <1390542276.32356.22.camel@joe-AO722>
Subject: Re: [PATCH 5/5] lustre: add myself to list of people to CC on
 lustre patches
From: Joe Perches <joe@perches.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>
Date: Thu, 23 Jan 2014 21:44:36 -0800
In-Reply-To: <1390538708-4120-6-git-send-email-green@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
	 <1390538708-4120-6-git-send-email-green@linuxhacker.ru>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a MAINTAINERS entry too?
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5c5d554..9ca5de8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8284,6 +8284,14 @@ W:	http://www.lirc.org/
 S:	Odd Fixes
 F:	drivers/staging/media/lirc/
 
+STAGING - LUSTRE
+M:	Andreas Dilger <andreas.dilger@intel.com>
+M:	Oleg Drokin <oleg.drokin@intel.com>
+M:	Peng Tao <tao.peng@emc.com>.
+L:	hpdd-discuss <hpdd-discuss@lists.01.org>
+S:	Odd Fixes
+F:	drivers/staging/lustre/
+
 STAGING - NVIDIA COMPLIANT EMBEDDED CONTROLLER INTERFACE (nvec)
 M:	Julian Andres Klode <jak@jak-linux.org>
 M:	Marc Dietrich <marvin24@gmx.de>


