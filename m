Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbbANR1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:27:04 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36302 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbANR1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:27:00 -0500
Date: Wed, 14 Jan 2015 12:26:32 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 0/2] crypto: AF_ALG: add AEAD and RNG support
Message-ID: <20150114172632.GB24512@localhost.localdomain>
References: <5489736.JvWhZNrmuD@tachyon.chronox.de>
 <20150114094631.GB15294@localhost.localdomain>
 <20150114110011.GA18099@gondor.apana.org.au>
 <5006702.rWOQQ5L1VO@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5006702.rWOQQ5L1VO@tachyon.chronox.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 04:31:44PM +0100, Stephan Mueller wrote:
> Am Mittwoch, 14. Januar 2015, 22:00:11 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Wed, Jan 14, 2015 at 04:46:31AM -0500, Neil Horman wrote:
> > > On Wed, Jan 14, 2015 at 04:52:29AM +0100, Stephan Mueller wrote:
> > > > Hi,
> > > > 
> > > > This patch set adds AEAD and RNG support to the AF_ALG interface
> > > > exported by the kernel crypto API. By extending AF_ALG with AEAD and RNG
> > > > support, all cipher types the kernel crypto API allows access to are
> > > > now accessible from userspace.
> > > > 
> > > >  crypto/Kconfig      |   9 +
> > > >  crypto/Makefile     |   1 +
> > > >  crypto/algif_aead.c | 680
> > > >  ++++++++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed,
> > > >  690 insertions(+)
> > > >  create mode 100644 crypto/algif_aead.c
> > > 
> > > Where are the RNG bits?
> > 
> > They've already been merged.
> 
> Please also see my change log for v7:
> ...
> * RNG: patch dropped as it was applied
> ...
> 
> To ensure consistency, I did not change the intro part of my description.
Ah, thanks for the clarification
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
> > 
> > Cheers,
> 
> 
> -- 
> Ciao
> Stephan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
