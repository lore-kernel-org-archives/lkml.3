Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaJPRmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:42:54 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29086 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaJPRmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:42:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/64YCLr5ljGMcaDcnjH1uQjv4NlGlmwCY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2A39360086A
Date: Thu, 16 Oct 2014 13:42:45 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stephan Mueller <smueller@chronox.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel crypto API interface specification
Message-ID: <20141016174245.GL17447@titan.lakedaemon.net>
References: <7502136.9BkWHTZ0th@myon.chronox.de>
 <20141016132501.GI17447@titan.lakedaemon.net>
 <20141016150604.GK17447@titan.lakedaemon.net>
 <2081738.uvS0jMPrv1@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2081738.uvS0jMPrv1@myon.chronox.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 06:50:58PM +0200, Stephan Mueller wrote:
> Am Donnerstag, 16. Oktober 2014, 11:06:05 schrieb Jason Cooper:
> 
> Hi Jason,
> 
> > On Thu, Oct 16, 2014 at 09:25:01AM -0400, Jason Cooper wrote:
> > > + Grant, Geert,
> > > 
> > > Stephan has created some great example code for both the kernel crypto
> > > API and the userspace crypto API.  As examples tend to bitrot, I was
> > > wondering if the code could serve as test code.  Then it would have a
> > > triple role: API regression testing, crypto test suite, and reference
> > > implementation.
> > > 
> > > Original patch is here:
> > >   https://lkml.kernel.org/r/7502136.9BkWHTZ0th@myon.chronox.de
> > > 
> > > On Thu, Oct 16, 2014 at 09:19:08AM +0200, Stephan Mueller wrote:
> > > > Am Mittwoch, 15. Oktober 2014, 13:58:00 schrieb Jason Cooper:
> > > > > On Tue, Oct 14, 2014 at 09:46:50PM +0200, Stephan Mueller wrote:
> > ...
> > 
> > > > > Perhaps the userspace API example should be a separate file with this
> > > > > text at the top?  Seems odd having it at the end.  Also, if you copied
> > > > > it from cryptsetup, is the copyright info correct?
> > > > 
> > > > I did not copy it from cryptsetup. I only used it as a basis, especially
> > > > with the data structure handling in _kcapi_cipher_crypt. But you are
> > > > right, I changed the license for the user space by taking the
> > > > cryptsetup license.> 
> > > Ok.  It looks like Geert and Grant took part in the kernel test
> > > unconference, so I'm adding them to the Cc.  I hope they can give us
> > > some pointers as to where we could hook in this code.  Then we can
> > > simply refer to it from the userspace API document.
> > 
> > tools/testing/selftests/crypto would be a good location for the example
> > code in the next version of this patch.  Make sure to take a look at
> > tools/testing/selftests/README.txt.
> 
> Well, I have written a FIPS 140-2 CAVS test harness covering all ciphers NIST 
> is interested. Maybe this can go there?

Assuming you own the code and are willing to license it under and
compatible license, then yes.  I would keep it a separate test from
other crypto tests, though.

There may be some push back wrt it being FIPS 140-2.  But I think it's
worth considering.

thx,

Jason.
