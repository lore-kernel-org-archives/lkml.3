Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaBSOnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:43:21 -0500
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:45416 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752542AbaBSOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:43:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1719:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:6117:7652:7901:7903:9010:9025:9388:9562:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13072:13311:13357:14106,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: map27_914243a7ee557
X-Filterd-Recvd-Size: 1616
Message-ID: <1392820997.24844.5.camel@joe-AO722>
Subject: Re: scripts/get_maintainer.pl: http addresses in MAINTAINER's L:
 line
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Wed, 19 Feb 2014 06:43:17 -0800
In-Reply-To: <1392805582.27558.30.camel@x220>
References: <1392805582.27558.30.camel@x220>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 11:26 +0100, Paul Bolle wrote:
> Andrew, Joe,
> 
> (You two touched this script the most, it seems.)
> 
> The MAINTAINERS entry for the "TARGET SUBSYSTEM" uses an http address
> for one of its L: lines. The "DC395x SCSI driver" does that too. This
> shows up as a useless line in the output of scripts/get_maintainer.pl:
>     [...]
>      (open list:TARGET SUBSYSTEM)
>     [...]
> 
> Should another test be added to get_maintainer.pl (which is already over
> 2000 lines long) or should these two entries be converted to "W:"?

I'd change the line in MAINTAINERS from

L:	http://groups.google.com/group/linux-iscsi-target-dev
to
W:	http://groups.google.com/group/linux-iscsi-target-dev

as it's a web based discussion not an email address.


