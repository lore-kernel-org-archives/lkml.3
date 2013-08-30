Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3H3ITm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:19:42 -0400
Received: from mail.abilis.ch ([195.70.19.74]:19058 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab3H3ITj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:19:39 -0400
Date: Fri, 30 Aug 2013 10:19:06 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
Message-ID: <20130830081905.GB6766@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com>
 <20130805115118.GF20936@ab42.lan>
 <CACRpkdaXqHHF5oDsWSCyhzUOurrxfLhS40=csGJFT8fK4WkA4A@mail.gmail.com>
 <20130821155751.GB3046@ab42.lan>
 <CACRpkda5KT8QWDK+76j0_yfW2LShOb_3mkssFd=nt8tLXx2Q3Q@mail.gmail.com>
 <20130829073542.GA23079@ab42.lan>
 <CACRpkdb4N=ovyu1j9AOnvHePr=8dSunD5aTsftXeD8dbBsmT4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb4N=ovyu1j9AOnvHePr=8dSunD5aTsftXeD8dbBsmT4A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 10:24:30AM +0200, Linus Walleij wrote:
> On Thu, Aug 29, 2013 at 9:35 AM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> > On Wed, Aug 28, 2013 at 08:49:36PM +0200, Linus Walleij wrote:
> >> On Wed, Aug 21, 2013 at 5:57 PM, Christian Ruppert
> >> <christian.ruppert@abilis.com> wrote:
> >> > On Wed, Aug 14, 2013 at 06:53:56PM +0200, Linus Walleij wrote:
> >> >>
> >> >> OK, that can also be called a "bank" or "register" but whatever.
> >> >
> >> > As you suggested below I re-read Documentation/pinctrl.txt and it got me
> >> > even more confused:
> >> > Am I right in my understanding that the whole concept of a
> >> > "port/bank/register" or whatever we would like to call it does not exist
> >> > in the pinctrl framework?
> >>
> >> Not that I know :-)
> >>
> >> If what it means is a number of registers from address x thru x+n
> >> words in memory that is called a register range usually, the
> >> Device Tree "regs" property.
> >>
> >> If you're referring to a subset of registers dealing with a batch
> >> of pins or a single pin that can use whatever terminology you
> >> want, I consider it a driver-internal detail. Some GPIO drivers
> >> talk about "ports" when they have e.g. 2 x 32bit registers
> >> handling a total of 64 pins, then that is port 0 and port 1 or
> >> something like this, but it's really up to the driver.
> >
> > Actually, it's a set of pins the muxing of which is controlled by the
> > same register. E.g. Port A is the set of all the pins which are
> > controlled by register field A.
> 
> What is wrong with calling that a "pin-set register" or something?

Nothing. Except perhaps that I hope we can confine that concept to the
driver and thus eliminate the need to talk about it altogether ;)

Greetings,
  Christian
