Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3DSJZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:25:37 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62966 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab3DSJZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130419090558.GA13283@mudshark.cambridge.arm.com>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
	<ede8ee08bb2616c2ed642200e3357367@localhost>
	<CAAHg+HhajHFC=1nh6YQNgpf=Na2FqcsYJ=t+ag9QiTg6TxUz9w@mail.gmail.com>
	<bb1193983de3ea9f4df1a570441df34c@localhost>
	<CAAHg+HhtCorArCmx=ha0=64+SJZiizzrDUKSPLV=N+OzO8zAxQ@mail.gmail.com>
	<20130419090558.GA13283@mudshark.cambridge.arm.com>
Date: Fri, 19 Apr 2013 14:55:35 +0530
Message-ID: <CAAHg+HipCX2ma6brxj9Kgc3ew39b5e30grLwyun9CViif-5wZQ@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,
On 19 April 2013 14:35, Will Deacon <will.deacon@arm.com> wrote:
> Hello,
>
> On Thu, Apr 18, 2013 at 09:48:49AM +0100, Pranavkumar Sawargaonkar wrote:
>> Actually i thought adding a config register will be easier to add a
>> code than writing entire emulation as 8250 emulation will require to
>> deal with dealing with more registers and more code.
>
> kvmtool already has an 8250 emulation! All we need to do is hack together
> something which will allow us to instantiate those ioport devices in a more
> flexible manner (namely, inside the MMIO space for ARM). For earlyprintk, I
> suspect we can get away without an interrupt too, which should simplify
> things a bit to start with.
>
> Regardless of the outcome of this discussion, I think getting the 8250
> working on ARM is definitely something worth doing. If I get time, I'll take
> a look.

I am not against using 8250 emulation (as far as it solves printk
issues for kernel booting logs), but my point is why not to add early
read-write support for virtio console, which also can be useful in
emulation less mach-virt environment also ?

Thanks,
Pranav

>
> Will
