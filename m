Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaBESlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:41:23 -0500
Received: from smtprelay0028.hostedemail.com ([216.40.44.28]:39885 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753919AbaBESkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:40:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1712:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3867:3868:4321:5007:6119:7652:7901:7903:10004:10400:10848:11232:11657:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: berry30_5771d53f87724
X-Filterd-Recvd-Size: 1410
Message-ID: <1391625600.30094.24.camel@joe-AO722>
Subject: rfc: fs directories without MAINTAINER section entries
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 05 Feb 2014 10:40:00 -0800
In-Reply-To: <20140205175222.28d6788471b6551831440ed0@skynet.be>
References: <20140205175222.28d6788471b6551831440ed0@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-05 at 17:52 +0800, Fabian Frederick wrote:
> Adding generic fsdevel section for ADFS.
> I guess status can be considered 'orphan' like affs and befs.

and cramfs and efs and hfs and hfsplus too.

Other fs/ directories without MAINTAINERS sections:

fs/devpts
fs/exportfs
fs/isofs
fs/kernfs
fs/minix
fs/nls
fs/openpromfs
fs/proc
fs/qnx6
fs/ramfs
fs/romfs

Anyone have clues what to do with these?

Nothing?
Add new sections for each of them as Orphan?
Add new sections with Al as Maintained? </joke>


