Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaKCRrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:47:48 -0500
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:48957 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751159AbaKCRrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:47:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3870:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6261:7903:7974:8957:8985:9025:10004:10400:10848:10967:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:13845:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rain01_7d73f727d440d
X-Filterd-Recvd-Size: 1571
Message-ID: <1415036860.17743.25.camel@perches.com>
Subject: Re: [PATCH] CodingStyle: Add a chapter on conditional compilation
From: Joe Perches <joe@perches.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Nov 2014 09:47:40 -0800
In-Reply-To: <20141103114656.3bf200df@lwn.net>
References: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
	 <20141103114656.3bf200df@lwn.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 11:46 -0500, Jonathan Corbet wrote:
> On Wed, 29 Oct 2014 11:15:17 -0700
> Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > Document several common practices and conventions regarding conditional
> > compilation, most notably the preference for ifdefs in headers rather
> > than .c files.
> 
> OK, I've picked this one up for my 3.19 docs pull.

I think that Al Viro's suggestion from awhile ago:

https://lkml.org/lkml/2013/3/20/388

could still be in CodingStyle somewhere or in
another document like CodingStyleSuggestions.

Another thing that could go is the suggestion to
use Lindent.

https://lkml.org/lkml/2013/2/11/390


