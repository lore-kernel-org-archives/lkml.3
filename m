Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaHROp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:45:29 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:43462 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaHROp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:45:27 -0400
X-ASG-Debug-ID: 1408373123-0759e7416b43aa9e0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 18 Aug 2014 16:45:21 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Felipe Balbi <balbi@ti.com>
CC: <linux-serial@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] omap-serial high-speed fixes/improvements
Message-ID: <20140818144521.GB9319@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [RFC PATCH 0/3] omap-serial high-speed fixes/improvements
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <20140818134507.GC9662@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140818134507.GC9662@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1408373123
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.8579
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 08:45:08AM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jul 29, 2014 at 04:52:54PM +0200, Frans Klaver wrote:
> > Hi,
> > 
> > Here's a couple of patches that should improve the behavior of the omap serial
> > driver at high data rates and baud rates.
> > 
> > I was actually surprised to see that proper dma support isn't there yet, but
> > there you go. Anyone got news on that, by the way?
> 
> please resend these patches and make sure you get the right Cc list.
> 
> You're missing linux-omap, Tony Lingren, linux-arm-kernel...
> scripts/get_maintainer.pl would give you a more exaustive list of
> people to Cc.

This CC list is what I got from get_maintainer.pl. I should have at
least remembered to add linux-omap, though. I take it everyone gets all
patches for consistency?

Thanks,
Frans
