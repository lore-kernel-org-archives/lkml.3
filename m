Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3HLQqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:46:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41231 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab3HLQqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:46:08 -0400
Date: Mon, 12 Aug 2013 17:45:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130812164548.GE23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk> <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 05:24:50PM +0100, Peter Maydell wrote:
> On 12 August 2013 01:40, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 08/11/2013 03:04 PM, Russell King - ARM Linux wrote:
> >> It could be that it's qemu's PCI routing is wrong - it's not the first
> >> time that qemu has got something wrong.
> 
> QEMU 1.5 has had its Versatile PCI routing code rewritten to
> correspond with the hardware (cross-tested versus Arnd Bergmann's
> patchset
> http://marc.info/?l=linux-arm-kernel&m=128707282403376&w=2
> which was run on real versatilePB backplane hardware and
> could handle a PCI SATA card). I believe it to be correct,
> and I spent a fairly long time wading through the various bits
> of documentation and testing those kernel patches on h/w.

The documentation is totally useless - I've been through it several times
and it just doesn't give the necessary information to work out what the
routing actually is.  The only place that's documented is in the circuits,
which are impossible to get hold of (even asking ARM for them doesn't get
anywhere: basically, all information has been destroyed.)

> If somebody would like to fix the kernel I am happy to
> locate the PCI backplane and test everything (again).
> I would suggest that producing some patches which work
> with QEMU 1.5 or later would be a good start; then we
> can test on h/w as confirmation before they are applied.

If someone is willing to send me some definitive information, then
the kernel will get fixed.  All the time that there is no definitive
information, there is no point what so ever changing the kernel.

In other words, if you have the circuit diagrams or other documentation
which definitively identifies the wiring, then please send it to me.
