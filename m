Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936564AbaH1KYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:24:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33291 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934654AbaH1KYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:24:44 -0400
Date: Thu, 28 Aug 2014 11:24:07 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Wang Nan <wangnan0@huawei.com>, "David A. Long" <dave.long@linaro.org>,
        Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pei Feiyue <peifeiyue@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ARM: probes: check stack operation when decoding
Message-ID: <20140828102406.GH22580@arm.com>
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>
 <1409144552-12751-2-git-send-email-wangnan0@huawei.com>
 <53FEFB93.2010009@hitachi.com>
 <20140828102021.GC30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828102021.GC30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 11:20:21AM +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 28, 2014 at 06:51:15PM +0900, Masami Hiramatsu wrote:
> > (2014/08/27 22:02), Wang Nan wrote:
> > > This patch improves arm instruction decoder, allows it check whether an
> > > instruction is a stack store operation. This information is important
> > > for kprobe optimization.
> > > 
> > > For normal str instruction, this patch add a series of _SP_STACK
> > > register indicator in the decoder to test the base and offset register
> > > in ldr <Rt>, [<Rn>, <Rm>] against sp.
> > > 
> > > For stm instruction, it check sp register in instruction specific
> > > decoder.
> > 
> > OK, reviewed. but since I'm not so sure about arm32 ISA,
> > I need help from ARM32 maintainer to ack this.
> 
> What you actually need is an ack from the ARM kprobes people who
> understand this code.  That would be much more meaningful than my
> ack.  They're already on the Cc list.

Tixy, can you take a look please?

Will
