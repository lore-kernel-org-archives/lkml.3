Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3HFKbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:31:23 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44504 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755913Ab3HFKbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:31:22 -0400
Date: Tue, 6 Aug 2013 11:30:44 +0100
From: Dave P Martin <Dave.Martin@arm.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 1/7] EFI stub documentation updates
Message-ID: <20130806103044.GC2791@e103592.cambridge.arm.com>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-2-git-send-email-roy.franz@linaro.org>
 <20130805141221.GC2755@localhost.localdomain>
 <CAFECyb9h7aSzOAHC0t-xT1mNxW_CuMqpU8zGD50ZzZYQ74d0fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb9h7aSzOAHC0t-xT1mNxW_CuMqpU8zGD50ZzZYQ74d0fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:56:12AM +0100, Roy Franz wrote:
> On Mon, Aug 5, 2013 at 7:12 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> > On Fri, Aug 02, 2013 at 02:29:02PM -0700, Roy Franz wrote:
> >> The ARM kernel also has an EFI stub which works largely the same way
> >> as the x86 stub, so move the documentation out of x86 directory and
> >> update to reflect that it is generic, and add ARM specific text.
> >>
> >> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> >> ---
> >>  Documentation/efi-stub.txt     |   78 ++++++++++++++++++++++++++++++++++++++++
> >>  Documentation/x86/efi-stub.txt |   65 ---------------------------------
> >>  arch/x86/Kconfig               |    2 +-
> >>  3 files changed, 79 insertions(+), 66 deletions(-)
> >>  create mode 100644 Documentation/efi-stub.txt
> >>  delete mode 100644 Documentation/x86/efi-stub.txt
> >>
> >> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> >> new file mode 100644
> >> index 0000000..7837df1
> >> --- /dev/null
> >> +++ b/Documentation/efi-stub.txt
> >> @@ -0,0 +1,78 @@
> >> +                       The EFI Boot Stub
> >> +                  ---------------------------
> >> +
> >> +On the x86 and ARM platforms, a bzImage can masquerade as a PE/COFF image,
> >> +thereby convincing EFI firmware loaders to load it as an EFI
> >> +executable. The code that modifies the bzImage header, along with the
> >
> >
> > Minor nit, I don't think there is such a thing as "bzImage" for ARM.
> >
> > Cheers
> > ---Dave
> >
> Yeah, I don't thinks so either...  How about:
> 
> On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade....

Souds fine to me

Cheers
---Dave
