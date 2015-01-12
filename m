Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbbALOI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:08:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40968 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbALOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:08:26 -0500
Date: Mon, 12 Jan 2015 17:06:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pavel Machek <pavel@denx.de>
Cc: Konrad Zapalowicz <bergo.torino@gmail.com>, mark.rutland@arm.com,
        linux-doc@vger.kernel.org, rubini@gnudd.com,
        pantelis.antoniou@konsulko.com, hpa@zytor.com,
        s.trumtrar@pengutronix.de, devel@driverdev.osuosl.org,
        sameo@linux.intel.com, nico@linaro.org, iws@ovro.caltech.edu,
        michal.simek@xilinx.com, kyle.teske@ni.com,
        jgunthorpe@obsidianresearch.com, grant.likely@linaro.org,
        davidb@codeaurora.org, linus.walleij@linaro.org, cesarb@cesarb.net,
        devicetree@vger.kernel.org, jason@lakedaemon.net, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, atull <atull@opensource.altera.com>,
        broonie@kernel.org, philip@balister.org, akpm@linux-foundation.org,
        monstr@monstr.eu, gregkh@linuxfoundation.org,
        yvanderv@opensource.altera.com, linux-kernel@vger.kernel.org,
        balbi@ti.com, davem@davemloft.net, robh+dt@kernel.org, rob@landley.net,
        galak@codeaurora.org, dinguyen@opensource.altera.com,
        delicious.quinoa@gmail.com, m.chehab@samsung.com
Subject: Re: [PATCH v8 0/4] FPGA Manager Framework
Message-ID: <20150112140642.GD7568@mwanda>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <20150110181120.GA26067@t400>
 <alpine.DEB.2.10.1501111004580.2556@shineypoop>
 <20150111162426.GC26067@t400>
 <20150111195219.GA25760@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111195219.GA25760@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 08:52:19PM +0100, Pavel Machek wrote:
> 
> Actually, why not? Tools should know to look at From: in the
> commit. AFAICT, Alan has it set up correctly.
> 								Pavel

Normally, the Extra From header should only be used if the patches were
sent on behalf of someone else.  It's just a bit of a pain to verify
that the Extra From matches the email headers.

Also sometimes people can't get their corporate email configured
properly for patches and so they use gmail but specify an Extra From so
their employer gets credit...  That's ok.

The patches apply fine so it's not a "redo the patch" type thing, it's
just a "In the long term, please, fix your email From header so the
Extra From isn't needed."

regards,
dan carpenter

