Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3HNM5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:57:15 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53051 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3HNM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:57:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130814124904.GQ23006@n2100.arm.linux.org.uk>
References: <20130812164548.GE23006@n2100.arm.linux.org.uk>
 <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com>
 <20130812200628.GG23006@n2100.arm.linux.org.uk> <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com>
 <20130812212149.GH23006@n2100.arm.linux.org.uk> <CAFEAcA_0kzS=Z5oTxrr=B74wjf1x=M6dXwH7Fcgf77Pca90Gjw@mail.gmail.com>
 <20130812221250.GI23006@n2100.arm.linux.org.uk> <20130812230408.GA4420@roeck-us.net>
 <20130814103346.GN23006@n2100.arm.linux.org.uk> <CAFEAcA8u_c=seOQ+y44H2Vpefyx4EisiZ-ZqBxuPsyoYjCt3vQ@mail.gmail.com>
 <20130814124904.GQ23006@n2100.arm.linux.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 14 Aug 2013 13:56:52 +0100
Message-ID: <CAFEAcA-V=DqomASFDaQhOsnXPePZ3iA7AVV8pSyRkDxbmT4n8A@mail.gmail.com>
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

On 14 August 2013 13:49, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Aug 14, 2013 at 01:44:44PM +0100, Peter Maydell wrote:
>> Yes, I definitely think we should test on the hardware before we
>> land yet another change to this PCI code that hasn't really been
>> thoroughly tested on anything. I have the board/backplane on my
>> desk but it'll be later in the week before I can do the testing
>> (currently still messing with uboot config to get it to actually
>> boot a kernel).
>
> Realview or Versatile?  I still need to sort out Realview.

PB926, so versatile. Let's get that one straightened out first,
since at the moment the kernel has no realview PCI support at
all. I should be able to get a PB1176 to go in the backplane
for testing that, though.

-- PMM
