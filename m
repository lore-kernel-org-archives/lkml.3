Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3HaLyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:54:46 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:53540 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab3HaLyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:54:44 -0400
Date: Sat, 31 Aug 2013 13:55:19 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
Message-ID: <20130831135519.6ab0e163@armhf>
In-Reply-To: <20130831112430.GD6617@n2100.arm.linux.org.uk>
References: <20130828113521.35c53365@armhf>
	<521DCD80.9010105@gmail.com>
	<20130831125128.0e3a23c7@armhf>
	<20130831112430.GD6617@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013 12:24:31 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > According to the Dove specification, the audio controller works with
> > the samples rates 44.1, 48 and 96 kHz, so, I don't see the usage of the
> > external clock, except when using the two audio controllers with
> > different sample rates.
	[snip]
> > But, BTW, as the kirkwood-i2 driver is written, this last case does not
> > work: for 44.1, 48 and 96 kHz, the external clock is never used and
> > there is only one DCO.  
> 
> This doesn't make sense.  "this last case" - what "case" are you referring
> to?  "there is only one DCO" ?  Yes, there is only one DCO, what is its
> relevance to the statement you're making?  And yes, in mainline we
> currently use the DCO for the standard 44.1, 48 and 96kHz sample rates.
> That's fine.  Confused.

Sorry, it was clear in my head :)

The last case was "when using the two audio controllers with different
sample rates" (I should have added "in the set [44.1, 48, 96 kHz]").
Then, with or without the availability of external clocks, both
controllers will set the unique DCO to two different rates.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
