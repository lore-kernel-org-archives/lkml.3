Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaE0TfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:35:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57461 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbaE0TfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:35:04 -0400
Date: Tue, 27 May 2014 20:34:26 +0100
From: Will Deacon <will.deacon@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140527193425.GC30751@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
 <1401054470.3958.30.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401054470.3958.30.camel@pasglop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 10:47:50PM +0100, Benjamin Herrenschmidt wrote:
> On Thu, 2014-05-22 at 17:47 +0100, Will Deacon wrote:
> > Hi all,
> > 
> > This is version 2 of the series I originally posted here:
> > 
> >   https://lkml.org/lkml/2014/4/17/269
> > 
> > Changes since v1 include:
> > 
> >  - Added relevant acks from arch maintainers
> >  - Fixed potential compiler re-ordering issue for x86 definitions
> > 
> > I'd *really* appreciate some feedback on the proposed semantics here, but
> > acks are still good :)
> > 
> > The original cover letter is duplicated below.
> 
> Question (sorry if I missed an existing explanation...), do we have an
> equivalent bunch for iomap ?

Do you mean the io{read,write} functions? Funnily enough, they're already
relaxed on ARM if you go by the semantics I've proposed. That implies we at
least need some Documentation to that effect...

What do you do on ppc?

Will
