Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3HNMpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:45:10 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:48879 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3HNMpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130814103346.GN23006@n2100.arm.linux.org.uk>
References: <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130812164548.GE23006@n2100.arm.linux.org.uk> <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com>
 <20130812200628.GG23006@n2100.arm.linux.org.uk> <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com>
 <20130812212149.GH23006@n2100.arm.linux.org.uk> <CAFEAcA_0kzS=Z5oTxrr=B74wjf1x=M6dXwH7Fcgf77Pca90Gjw@mail.gmail.com>
 <20130812221250.GI23006@n2100.arm.linux.org.uk> <20130812230408.GA4420@roeck-us.net>
 <20130814103346.GN23006@n2100.arm.linux.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 14 Aug 2013 13:44:44 +0100
Message-ID: <CAFEAcA8u_c=seOQ+y44H2Vpefyx4EisiZ-ZqBxuPsyoYjCt3vQ@mail.gmail.com>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 August 2013 11:33, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Aug 12, 2013 at 04:04:08PM -0700, Guenter Roeck wrote:
>> Hacked diff is below. Can I write that up as clean patch and submit it,
>> or do we need a test on real hardware ?
>
> Well, if we want to ensure that it is really correct, the sensible thing
> to do is to try it on real hardware, otherwise we're risking yet another
> change to this.
>
> Earlier in this thread, some people said that they have the hardware, so
> it shouldn't be that difficult to get it tested on real stuff.

Yes, I definitely think we should test on the hardware before we
land yet another change to this PCI code that hasn't really been
thoroughly tested on anything. I have the board/backplane on my
desk but it'll be later in the week before I can do the testing
(currently still messing with uboot config to get it to actually
boot a kernel).

thanks
-- PMM
