Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3BEXkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:40:31 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49989 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3BEXka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:40:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,610,1355126400"; 
   d="scan'208";a="24083226"
Date: Tue, 5 Feb 2013 17:40:27 -0600
From: rkuo <rkuo@codeaurora.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
Message-ID: <20130205234026.GA4939@codeaurora.org>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
 <5102BB38.3050207@imgtec.com>
 <201301260025.10020.arnd@arndb.de>
 <51062460.9060902@synopsys.com>
 <20130130074452.f67abeeaae3a00d046f5699f@canb.auug.org.au>
 <51110F1A.8090606@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51110F1A.8090606@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I actually found someone locally who signed my key.

Good luck!




On Tue, Feb 05, 2013 at 07:24:34PM +0530, Vineet Gupta wrote:
> On Wednesday 30 January 2013 02:14 AM, Stephen Rothwell wrote:
> > Hi Vineet,
> > 
> > On Mon, 28 Jan 2013 12:40:24 +0530 Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> >>
> >> Stephen, can you please add the following branch (rebased off 3.8-rc5) to linux-next
> >>
> >> git://github.com/foss-for-synopsys-dwc-arc-processors/linux.git  arc-next
> > 
> > Added from today (though there may not be a linux-next release today).
> 
> Thanks Stephan - I see it in there for last 2 days now.
> 
> >> While the first pull request can go directly from github, I presume the logistics
> >> for setting up accounts on kernel.org will only kick start after the first batch
> >> of code has been accepted. I can't seem to find any discussions on lists to that
> >> effect.
> > 
> > Linus prefers to not pull from github, but will if you ask him to pull a
> > tag signed with a verifiable gpg key.  This is not a requirement if your
> > tree is on kernel.org (though you still need a verifiable gpg key to get
> > a kernel.org account).
> 
> At the moment I don't have my key signed by anyone else. James pointed me to
> http://www.kernel.org/signature.html so I've added myself to the google map page
> and there's obviously no one near me. So how do we solve this - can I call a
> developer - who say trusts me - and get him to sign using my key-id.
> 
> Richard I believe you were in a similar situation when submitting your port - how
> did you end up solving this.
> 
> Damn! I was at ELCE back in November but wasn't aware of need for doing this.
> 
> Thx,
> -Vineet
