Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3A1PEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:04:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56739 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3A1PEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:04:38 -0500
Date: Mon, 28 Jan 2013 15:04:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Roland Stigge <stigge@antcom.de>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 2/2] gpio: pca953x: use managed resources
Message-ID: <20130128150410.GM23505@n2100.arm.linux.org.uk>
References: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com> <1359133168-14879-3-git-send-email-gregory.clement@free-electrons.com> <CACRpkdaEH+hqOo6i+4Lz+T4B+oAvCj+v0Ycr576yV2fWN2VNvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaEH+hqOo6i+4Lz+T4B+oAvCj+v0Ycr576yV2fWN2VNvg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 11:17:48AM +0100, Linus Walleij wrote:
> On Fri, Jan 25, 2013 at 5:59 PM, Gregory CLEMENT
> <gregory.clement@free-electrons.com> wrote:
> 
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > Using the devm_* managed resources the pca driver can be simplified
> > and cut down on boilerplate code.
> >
> > [gcl: fixed a inccorect reference to a removed label, "goto fail_out"
> > became "return ret"]
> 
> Oh now "gcl" means both Grant C. Likely and Gregory CLement :-)

I'd say gcl means Grant C. Likely.  gc would be Gregory Clement.
Initials. :)  Using anything else results in yet more many namespace
clashes.

Maybe we should switch to a numeric namespace instead? :)
