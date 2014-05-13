Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaEMTAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:00:33 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:58457 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752163AbaEMTAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:00:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:965:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3871:3873:3874:4321:4385:4390:4395:5007:7652:10004:10226:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoes36_5aa730f975726
X-Filterd-Recvd-Size: 1336
Message-ID: <1400007621.24350.47.camel@joe-AO725>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
From: Joe Perches <joe@perches.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Date: Tue, 13 May 2014 12:00:21 -0700
In-Reply-To: <20140513185312.GB2738@mguzik.redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
	 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
	 <1400006371.24350.45.camel@joe-AO725>
	 <20140513185312.GB2738@mguzik.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 20:53 +0200, Mateusz Guzik wrote:
> This is the same code which you can find at the end of the function.
> I added the label so that I can write freeze printk only once.

Yes, but for a read-only filesystem is the message useful?

