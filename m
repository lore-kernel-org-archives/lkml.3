Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaEWOjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:39:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47206 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbaEWOjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:39:06 -0400
Date: Fri, 23 May 2014 15:38:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 14/18] sparc: io: implement dummy relaxed accessor
 macros for writes
Message-ID: <20140523143810.GE21319@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
 <1400777250-17335-15-git-send-email-will.deacon@arm.com>
 <20140522181838.GA30632@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522181838.GA30632@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 07:18:38PM +0100, Sam Ravnborg wrote:
> On Thu, May 22, 2014 at 05:47:26PM +0100, Will Deacon wrote:
> > write{b,w,l,q}_relaxed are implemented by some architectures in order to
> > permit memory-mapped I/O accesses with weaker barrier semantics than the
> > non-relaxed variants.
> > 
> > This patch adds dummy macros for the write accessors to sparc, in the
> > same vein as the dummy definitions for the relaxed read accessors. The
> > existing relaxed read{b,w,l} accessors are moved into asm/io.h, since
> > they are identical between 32-bit and 64-bit machines.
> > 
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> Look good:
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks, Sam.

> But you should wait for David's ack too.

Yeah, I still need to get buy-in on the semantics from the PPC folks
anyway.

Will
