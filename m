Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbaGAMrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:47:25 -0400
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:58758 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754767AbaGAMrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:47:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3868:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4043:4321:5007:6119:6120:7652:7903:8985:9025:9388:10004:10400:10848:11232:11257:11658:11914:12043:12517:12519:12682:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wood96_7a70091fde712
X-Filterd-Recvd-Size: 1468
Message-ID: <1404218840.2717.35.camel@joe-AO725>
Subject: Re: [RFC 1/1] proc: constify seq_operations
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>, LKML <linux-kernel@vger.kernel.org>,
        dwalter@google.com
Date: Tue, 01 Jul 2014 05:47:20 -0700
In-Reply-To: <CAFLxGvwa32SkiwACv8k4DtkSAD9CA8BU7QAb4Onp2WkYMPXgBw@mail.gmail.com>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be>
	 <20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
	 <20140701081759.GA19708@infradead.org>
	 <CAFLxGvwa32SkiwACv8k4DtkSAD9CA8BU7QAb4Onp2WkYMPXgBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 10:41 +0200, Richard Weinberger wrote:
> BTW: Daniel Walter and I are currently working with grsec's constify gcc plugin.
> This plugin automatically makes structs const which contain only
> function pointers.

http://pax.grsecurity.net/docs/PaXTeam-H2HC13-PaX-gcc-plugins.pdf

Good luck, it might help for a few things.


