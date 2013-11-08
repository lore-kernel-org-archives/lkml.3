Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3KHQ5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:57:33 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56249 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab3KHQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:57:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX185FkWqhAotyMhYUUUl77rUguoakkPn8SI=
Date: Fri, 8 Nov 2013 11:57:21 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Olof Johansson <olof@lixom.net>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 7/9] ARM: add Armada 1500 and Sony NSZ-GS7 device
 tree files
Message-ID: <20131108165721.GA10335@titan.lakedaemon.net>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1383661723-17956-8-git-send-email-sebastian.hesselbarth@gmail.com>
 <0AF697FD-60AA-4B8B-A35F-3DF2FFBCF7AF@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0AF697FD-60AA-4B8B-A35F-3DF2FFBCF7AF@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 10:13:19AM -0600, Kumar Gala wrote:
> On Nov 5, 2013, at 8:28 AM, Sebastian Hesselbarth wrote:
...
> > .../devicetree/bindings/arm/marvell,berlin.txt     |   24 +++
> > arch/arm/boot/dts/Makefile                         |    2 +
> > arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts         |   29 +++
> > arch/arm/boot/dts/berlin2.dtsi                     |  227 ++++++++++++++++++++
> > 4 files changed, 282 insertions(+)
> > create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
> > create mode 100644 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts
> > create mode 100644 arch/arm/boot/dts/berlin2.dtsi
> 
> Haven't we been trying to go away from non-prefixed dts/dtsi?

hmmm, this is the first I've heard of that.  Although, your proposal
(in another thread) makes more sense now.  :)

> So should these be something like marvell-berlin2-...

I don't recall this being brought up at the summit, nor in Grant's
report.  I do need to give it a more careful read this weekend, though.
Perhaps I missed something.

thx,

Jason.
