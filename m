Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaBALOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 06:14:21 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:49869 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbaBALOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 06:14:18 -0500
Date: Sat, 1 Feb 2014 12:13:59 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/21] pinctrl: mvebu: restructure and remove
 hardcoded addresses from Dove pinctrl
Message-ID: <20140201111359.GE26003@lunn.ch>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140130182925.GM10864@lunn.ch>
 <52EA9EFA.1030609@gmail.com>
 <20140130202500.GN10864@lunn.ch>
 <52EB080A.2020200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EB080A.2020200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 03:18:50AM +0100, Sebastian Hesselbarth wrote:
> On 01/30/2014 09:25 PM, Andrew Lunn wrote:
> >On Thu, Jan 30, 2014 at 07:50:34PM +0100, Sebastian Hesselbarth wrote:
> >>On 01/30/2014 07:29 PM, Andrew Lunn wrote:
> >>>On Tue, Jan 28, 2014 at 01:39:12AM +0100, Sebastian Hesselbarth wrote:
> >>>>This patch set is one required step for Dove to hop into mach-mvebu.
> >>>>Until now, pinctrl-dove was hardcoding some registers that do not
> >>>>directly belong to MPP core registers. This is not compatible with
> >>>>what we want for mach-mvebu.
> >>>
> >>>I think there might be something wrong here....
> >>
> >>There _is_ something wrong. I'll have a look at it. For the record,
> >>what SoC are you testing with? From the base address, I guess it is
> >>Kirkwood?
> >
> >Yes, Kirkwood. Sorry for not saying.
> 
> This time I push a branch before sending out the patches. Also, I
> think I'll postpone removal of hardcoded addresses until this is
> sorted out. The patch set was growing way to quick and I have to
> do this step-by-step for me and everybody else to actually understand ;)
> 
> So, at least the MVEBU guys should test the following branch on
> their SoCs. Again, I have tested Dove and now confirmed that settings
> are still correct. The others are compile-tested.
> 
> https://github.com/shesselba/linux-dove.git unstable/mvebu-pinctrl-v3.14_v3

Hi Sebastian

Tested on Kirkwood. /debug/pinctrl is now identical with and without
the patch.

I've not looked at the actual patches, but please add a 

Tested-by: Andrew Lunn <andrew@lunn.ch>

	   Andrew
