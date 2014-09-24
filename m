Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaIXK46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:56:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36088 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725AbaIXK44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:56:56 -0400
Date: Wed, 24 Sep 2014 11:56:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Cartwright <joshc@codeaurora.org>, Wim Van Sebroeck <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] watchdog: qcom: document device tree bindings
Message-ID: <20140924105600.GD5729@leverpostej>
References: <cover.1411513109.git.joshc@codeaurora.org>
 <337231c0fc8b16b4f37e1e3b85cb0246f357a64d.1411513109.git.joshc@codeaurora.org>
 <2941802.u7NP2737aD@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2941802.u7NP2737aD@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:44:44AM +0100, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 18:04:37 Josh Cartwright wrote:
> > +- clocks : shall contain the input clock phandle
> 
> Just nitpicking, but this is not just a phandle, it's a clock
> descriptor, which is a phandle followed by a set of arguments,
> which may be empty, depending the on the clock controller
> implementation.

We're _extremely_ inconsistent with terminology, so it's not confusing
people don't know what to put here.

Elsewhere people say "phandle + clock specifier" (which is correct),
"clock reference" (which is ok, but sounds like a phandle), etc. From
what I recall some documentation says some *-specifier properties
include the phandle too.

It would be really nice if we had one consistent way of refering to
phandle+args style properties.

> 
> I would just call it 'the input clock', rather than 'input clock
> phandle'.

That's fine by me, given clocks is a well-understood standard property.

Mark.
