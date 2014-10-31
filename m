Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbaJaNqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:46:50 -0400
Received: from mail.eperm.de ([89.247.134.16]:54159 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758408AbaJaNqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:46:48 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel crypto API interface specification
Date: Fri, 31 Oct 2014 14:46:41 +0100
Message-ID: <12522104.5yU5SNjzIg@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <201410311009.52713.marex@denx.de>
References: <7502136.9BkWHTZ0th@myon.chronox.de> <20141031072353.GC7563@gondor.apana.org.au> <201410311009.52713.marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 31. Oktober 2014, 10:09:52 schrieb Marek Vasut:

Hi Marek,

> On Friday, October 31, 2014 at 08:23:53 AM, Herbert Xu wrote:
> > On Fri, Oct 31, 2014 at 04:01:04AM +0100, Marek Vasut wrote:
> > > I can share the last state of the document I wrote. Currently,
> > > it is not possible for me to keep up with my workload and do
> > > anything else, so that's all I can do.
> > 
> > Posting your latest revision would be great.
> 
> Please see below, mine is much less complete than Stephan's though
> and likely contains some bugs.

Thank you for sharing.

I am in the last innings to complete a new patch set. I will see to merge your 
documentation with mine.

The upcoming patchset will cover the following changes:

- split out the user space interface documentation (and fix a bug -- I forgot 
a memset(0) in there)

- keep the "high-level" description in a document in Documentation/crypto/

- put the API function documentation into the header files (I hope that is ok 
that I touch these files to add comments)

-- 
Ciao
Stephan
