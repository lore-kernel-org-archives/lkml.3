Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab3KHU3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:29:45 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61445 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab3KHU3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:29:42 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ga6k41RZHo2nNlBkoYIy5tQe7KymT30Q=
Date: Fri, 8 Nov 2013 15:29:30 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Olof Johansson <olof@lixom.net>
Cc: Kumar Gala <galak@codeaurora.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 7/9] ARM: add Armada 1500 and Sony NSZ-GS7 device
 tree files
Message-ID: <20131108202930.GL10335@titan.lakedaemon.net>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1383661723-17956-8-git-send-email-sebastian.hesselbarth@gmail.com>
 <0AF697FD-60AA-4B8B-A35F-3DF2FFBCF7AF@codeaurora.org>
 <20131108165721.GA10335@titan.lakedaemon.net>
 <8DC09031-553C-4FD5-8F05-F93D6FE40F3A@codeaurora.org>
 <20131108182415.GG10335@titan.lakedaemon.net>
 <CAOesGMhfr3CNxKNRJa+eJepr2Fc-jx4rTQ7cPerTkQM-CyzuCg@mail.gmail.com>
 <20131108193054.GJ10335@titan.lakedaemon.net>
 <CAOesGMir+Zar0hskPQ+ZN6Z7+R-G5GhrafenQPgjZGbVGG9uwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMir+Zar0hskPQ+ZN6Z7+R-G5GhrafenQPgjZGbVGG9uwA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:10:27PM -0800, Olof Johansson wrote:
> On Fri, Nov 8, 2013 at 11:30 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Fri, Nov 08, 2013 at 11:14:07AM -0800, Olof Johansson wrote:
> >> On Fri, Nov 8, 2013 at 10:24 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> >> > On Fri, Nov 08, 2013 at 12:06:26PM -0600, Kumar Gala wrote:
> >> >>
> >> >> On Nov 8, 2013, at 10:57 AM, Jason Cooper wrote:
> >> >>
> >> >> > On Fri, Nov 08, 2013 at 10:13:19AM -0600, Kumar Gala wrote:
> >> >> >> On Nov 5, 2013, at 8:28 AM, Sebastian Hesselbarth wrote:
> >> >> > ...
> >> >> >>> .../devicetree/bindings/arm/marvell,berlin.txt     |   24 +++
> >> >> >>> arch/arm/boot/dts/Makefile                         |    2 +
> >> >> >>> arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts         |   29 +++
> >> >> >>> arch/arm/boot/dts/berlin2.dtsi                     |  227 ++++++++++++++++++++
> >> >> >>> 4 files changed, 282 insertions(+)
> >> >> >>> create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
> >> >> >>> create mode 100644 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts
> >> >> >>> create mode 100644 arch/arm/boot/dts/berlin2.dtsi
> >> >> >>
> >> >> >> Haven't we been trying to go away from non-prefixed dts/dtsi?
> >> >> >
> >> >> > hmmm, this is the first I've heard of that.  Although, your proposal
> >> >> > (in another thread) makes more sense now.  :)
> >> >> >
> >> >> >> So should these be something like marvell-berlin2-...
> >> >> >
> >> >> > I don't recall this being brought up at the summit, nor in Grant's
> >> >> > report.  I do need to give it a more careful read this weekend, though.
> >> >> > Perhaps I missed something.
> >> >>
> >> >> This was based on review comments Olof gave when we pushed some .dts
> >> >> files for MSM/APQ Qualcomm Technologies soc/boards.
> >> >
> >> > As Andrew Lunn mentioned to me earlier, we should consider the fact that
> >> > the dts file names are being used by Debian's flash-kernel.  Oh no!
> >> > Another ABI! ;-)
> >>
> >> Yes, the names are mostly stable. ST-Ericsson renamed their dts files
> >> and it caused some pain, some build environments have them hardcoded,
> >> etc.
> >>
> >> Still, it is a good idea to start adding new ones using family or
> >> vendor prefixes, so they are easier to group. Please keep that in mind
> >> on new ones too, Jason -- I don't think I've discussed with you in the
> >> past. :-)
> >
> > Nope, I definitely missed that if you did ;-)  Will do in the future.
> >
> > Perhaps now is the time to consider separating the dts filename from the
> > dtb filename?  I'm warming up to my idea of globalscale,mirabox.dtb...
> 
> Having a "dtb-install" make target that sets those up as softlinks
> could be a good idea, at least.

oooh, I like that.  Something like

$ dtc -L -o kirkwood-dreamplug.dtb kirkwood-dreamplug.dts
$ ls
...
globalscale,dreamplug.dtb -> kirkwood-dreamplug.dtb
...
kirkwood-dreamplug.dtb
...
$

Otherwise the build system would have to learn to parse dts/dtbs...

> I'm not sold on using them as filenames myself though.

fair enough.

thx,

Jason.
