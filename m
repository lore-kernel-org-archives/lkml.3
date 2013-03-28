Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3C1AcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:32:01 -0400
Received: from ozlabs.org ([203.10.76.45]:44065 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab3C1AcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:32:00 -0400
Date: Thu, 28 Mar 2013 11:31:56 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: drop even more unused Kconfig symbols
Message-ID: <20130328003156.GA8130@concordia>
References: <1363864206.1390.117.camel@x61.thuisdomein>
 <1364381495.1345.21.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364381495.1345.21.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:51:35AM +0100, Paul Bolle wrote:
> On Thu, 2013-03-21 at 12:10 +0100, Paul Bolle wrote:
> > diff --git a/arch/powerpc/platforms/wsp/Kconfig b/arch/powerpc/platforms/wsp/Kconfig
> > index 79d2225..9eea710 100644
> > --- a/arch/powerpc/platforms/wsp/Kconfig
> > +++ b/arch/powerpc/platforms/wsp/Kconfig
> > @@ -29,7 +29,3 @@ config PPC_CHROMA
> >  	default y
> >  
> >  endmenu
> > -
> > -config PPC_A2_DD2
> > -	bool "Support for DD2 based A2/WSP systems"
> > -	depends on PPC_A2
> 
> This part was not included in the "powerpc: remove PReP" follow up
> patch. Should I resend separately?

Yes thanks.

It was added in commit a1d0d98 "Add WSP platform" but should not have
been, it was to support bringup hacks that were never merged upstream.

cheers
