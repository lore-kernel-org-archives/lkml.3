Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3HNMtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:49:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41539 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab3HNMtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:49:20 -0400
Date: Wed, 14 Aug 2013 13:49:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130814124904.GQ23006@n2100.arm.linux.org.uk>
References: <20130812164548.GE23006@n2100.arm.linux.org.uk> <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com> <20130812200628.GG23006@n2100.arm.linux.org.uk> <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com> <20130812212149.GH23006@n2100.arm.linux.org.uk> <CAFEAcA_0kzS=Z5oTxrr=B74wjf1x=M6dXwH7Fcgf77Pca90Gjw@mail.gmail.com> <20130812221250.GI23006@n2100.arm.linux.org.uk> <20130812230408.GA4420@roeck-us.net> <20130814103346.GN23006@n2100.arm.linux.org.uk> <CAFEAcA8u_c=seOQ+y44H2Vpefyx4EisiZ-ZqBxuPsyoYjCt3vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA8u_c=seOQ+y44H2Vpefyx4EisiZ-ZqBxuPsyoYjCt3vQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 01:44:44PM +0100, Peter Maydell wrote:
> On 14 August 2013 11:33, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Aug 12, 2013 at 04:04:08PM -0700, Guenter Roeck wrote:
> >> Hacked diff is below. Can I write that up as clean patch and submit it,
> >> or do we need a test on real hardware ?
> >
> > Well, if we want to ensure that it is really correct, the sensible thing
> > to do is to try it on real hardware, otherwise we're risking yet another
> > change to this.
> >
> > Earlier in this thread, some people said that they have the hardware, so
> > it shouldn't be that difficult to get it tested on real stuff.
> 
> Yes, I definitely think we should test on the hardware before we
> land yet another change to this PCI code that hasn't really been
> thoroughly tested on anything. I have the board/backplane on my
> desk but it'll be later in the week before I can do the testing
> (currently still messing with uboot config to get it to actually
> boot a kernel).

Realview or Versatile?  I still need to sort out Realview.

The alternative is - I have both the Realview EB and Versatile PB926
here, but no backplane (it wasn't deemed to be necessary for me to
have such a thing.)  If someone wants to donate a backplane...
