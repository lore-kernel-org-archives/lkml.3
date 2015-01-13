Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbbAMXsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:48:15 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39094 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751369AbbAMXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:48:13 -0500
Date: Wed, 14 Jan 2015 00:47:59 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Olof Johansson <olof@lixom.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        ARM Maintainers <arm@kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: re-fromat AT91 part to match other entries
Message-ID: <20150113234759.GH3843@piout.net>
References: <20150112224203.GL22090@quad.lixom.net>
 <1421160180-23452-1-git-send-email-nicolas.ferre@atmel.com>
 <20150113230956.GA15087@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113230956.GA15087@quad.lixom.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On 13/01/2015 at 15:09:56 -0800, Olof Johansson wrote :
> On Tue, Jan 13, 2015 at 03:43:00PM +0100, Nicolas Ferre wrote:
> > The entries are separated as ARM V4/V5 and ARM V7 as some other per-SoC config
> > options may be removed in the near future.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> > Hi Olof,
> > 
> > This is an attempt to match other ARM SoC families format.
> > If you feel that the patch can be good, do not hesitate to take it yourself. I
> > don't plan to integrate it in any of my pull-request so it can appear quickly in
> > arm-soc and can be used by everyone.
> 
> Hi,
> 
> If you see what Peter did, he split up the rules per-SoC based on how
> things were selectable in Kconfig. Since you seem to have the Kconfig
> entries already, how about doing the same? That way the same information
> w.r.t. SoC family that you have as comments isn't lost either.
> 

You didn't see the patch set yet because it depends on a lot of other
series still being discussed but after the switch to multiplatform, the
only config option left will be SOC_AT91RM9200, SOC_AT91SAM9 (both
under SOC_SAM_V4_V5) and SOC_SAMA5, under SOC_SAM_V7.

That's our plan, unless you feel that we should keep one config option
per SoC.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
