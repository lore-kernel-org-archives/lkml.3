Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3KMA3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 19:29:35 -0500
Received: from smtprelay0080.hostedemail.com ([216.40.44.80]:55845 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753306Ab3KMA32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 19:29:28 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1536:1559:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3870:3872:3876:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4043:4250:4321:5007:6117:6119:7652:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13311:13357:13845,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grip90_5254e135b8928
X-Filterd-Recvd-Size: 1371
Message-ID: <1384302563.3665.28.camel@joe-AO722>
Subject: Re: [PATCH V3] printk/cache: Mark printk_once test variable
 __read_mostly
From: Joe Perches <joe@perches.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-metag@vger.kernel.org
Date: Tue, 12 Nov 2013 16:29:23 -0800
In-Reply-To: <CA+8MBb+rrAWSTTvO4cx32ju-QOAG6aHHxR9B=sLtGXR3q8DF0A@mail.gmail.com>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
	 <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
	 <1383244173.8740.9.camel@joe-AO722>
	 <CA+8MBb+rrAWSTTvO4cx32ju-QOAG6aHHxR9B=sLtGXR3q8DF0A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 16:23 -0800, Tony Luck wrote:
> Trying this again with HTML disabled in gmail so mailing lists will see it ...

try this:

https://lkml.org/lkml/2013/10/30/604


