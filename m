Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbbAMSFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:05:32 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36536 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848AbbAMSF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:05:29 -0500
Date: Tue, 13 Jan 2015 19:05:26 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 05/11] usb: gadget: at91_udc: Remove non-DT handling code
Message-ID: <20150113180526.GE3843@piout.net>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
 <1417606330-17753-6-git-send-email-boris.brezillon@free-electrons.com>
 <20150112213905.GI2858@saruman>
 <20150112225330.GQ2447@piout.net>
 <20150113163654.GI16533@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113163654.GI16533@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13/01/2015 at 10:36:54 -0600, Felipe Balbi wrote :
> > I've rebased that patch series but it depends on another one (the mfd:
> > syscon: part of "memory: add Atmel EBI (External Bus Interface)
> > driver") that is not taken yet so applying it now will break the
> > build. I still hope to get it merged for 3.20 and I'll resend it as
> > soon as possible.
> 
> In that case, we either take the entire series through MFD (including
> the gadget patches) or we delay the gadget patches until all
> dependencies have been sorted out.

I would prefer not to miss 3.20, can I resend the patches now so you can
review and ack them? Then they could go through the mfd tree.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
