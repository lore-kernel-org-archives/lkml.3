Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaK1LRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:17:49 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:52260 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbaK1LRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:17:48 -0500
Message-ID: <1417173456.1845.3.camel@linaro.org>
Subject: Re: Re: [PATCH v10 2/2] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Wang Nan <wangnan0@huawei.com>, will.deacon@arm.com,
        taras.kondratiuk@linaro.org, ben.dooks@codethink.co.uk, cl@linux.com,
        rabin@rab.in, davem@davemloft.net, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Fri, 28 Nov 2014 11:17:36 +0000
In-Reply-To: <20141128111327.GR3836@n2100.arm.linux.org.uk>
References: <1416551751-50846-1-git-send-email-wangnan0@huawei.com>
	 <1416551751-50846-3-git-send-email-wangnan0@huawei.com>
	 <1417099007.2041.6.camel@linaro.org> <5477E82A.3020208@hitachi.com>
	 <1417169308.1845.1.camel@linaro.org>
	 <20141128111327.GR3836@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-28 at 11:13 +0000, Russell King - ARM Linux wrote:
> On Fri, Nov 28, 2014 at 10:08:28AM +0000, Jon Medhurst (Tixy) wrote:
> > On Fri, 2014-11-28 at 12:12 +0900, Masami Hiramatsu wrote:
> > > (2014/11/27 23:36), Jon Medhurst (Tixy) wrote:
> > [...]
> > > > I thought it good to see what sort of benefits this code achieves,
> > > > especially as it could grow quite complex over time, and the cost of
> > > > that versus the benefit should be considered.
> > > 
> > > I don't think it's so complex. It's actually cleanly separated.
> > > However, ARM tree should have arch/arm/kernel/kprobe/ dir,
> > > since there are too many kprobe related files under arch/arm/kernel/ ...
> > 
> > Yes, that does seem like a good idea. Or rather a 'probes' directory to
> > also include uprobes as that shares a lot of code with kprobes.
> 
> If you want to do this, then please make it arch/arm/probes rather than
> making the directory tree deeper than it needs to be.

Yes, good point.

-- 
Tixy


