Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3H1N7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:59:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50895 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3H1N7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:59:14 -0400
Date: Wed, 28 Aug 2013 14:58:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130828135852.GM6617@n2100.arm.linux.org.uk>
References: <521DCD33.2070008@gmail.com> <20130828121943.1c8327ca@skate> <521DD057.4040208@gmail.com> <20130828131548.0009d613@skate> <521DE2B3.9050508@gmail.com> <20130828135827.2307c89e@skate> <20130828121320.GK6617@n2100.arm.linux.org.uk> <20130828142909.3521064b@skate> <20130828124255.GL6617@n2100.arm.linux.org.uk> <20130828145151.6db29d70@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828145151.6db29d70@skate>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 02:51:51PM +0200, Thomas Petazzoni wrote:
> I don't see how this makes this a different situation. See for example
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-April/161065.html
> and
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-March/087702.html
> where Arnd also said using the oldest SoC that has the same IP block as
> the compatible string was the right thing to do.

Well, I have a different opinion, and that's all there is to it.  However,
differing opinions aren't tolerated within the kernel community even if
they are equally valid, so I'll just shut up about after this mail.

> And? If that's a different IP block, it'll have a different compatible
> string, that's it.

There you go, you've just said why there's no problem with using a generic
compatible string.

> It does. We're exactly in this situation, as I will soon be working on
> Armada 370 audio support, and while the IP looks similar, I have
> checked all the details to see if it's exactly identical.

You seem to have missed something in that paragraph.  If it's exactly
identical, there isn't a problem. :)

> And Armada 370 is really a mvebu architecture: it's even supported in
> mach-mvebu/, while Kirkwood and Dove are not (yet).

Maybe it should be mach-kirkwood and not mach-mvebu by your reasoning
then!
