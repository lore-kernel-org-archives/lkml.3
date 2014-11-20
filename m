Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbaKTSXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:23:08 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:39595 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbaKTSXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:23:05 -0500
Date: Thu, 20 Nov 2014 18:23:04 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: Vignesh R <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, bcousson@baylibre.com
Subject: Re: [PATCH v2 0/3] Add support for ADC on am437x-gp and
 am43x-epos-evm
In-Reply-To: <20141114185049.GB7046@atomide.com>
Message-ID: <alpine.DEB.2.02.1411201821300.9204@utopia.booyaka.com>
References: <1415099728-10959-1-git-send-email-vigneshr@ti.com> <54657FFA.1070200@ti.com> <20141114185049.GB7046@atomide.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Tony Lindgren wrote:

> * Vignesh R <vigneshr@ti.com> [141113 20:09]:
> > 
> > On Tuesday 04 November 2014 04:45 PM, Vignesh R wrote:
> > > This series of patches enable ADC on am437x-gp-evm and am43x-epos-evm.
> > > The ADC clock hwmod data of am33xx has been moved to commom place so that
> > > both am43xx and am33xx can reuse them.
> > > tscadc DT node has been adided to am437x-gp and am43x-epos dt files.
> > > With these patches, ADC functionalities are now available on am43xx.
> > > 
> > > Changelog:
> > > 
> > > v2:
> > > Removed phy addresses in hwmod. Using DT instead.
> > > Removed unused "ti,am4372" compatible string.
> > > Use macro to set clk domain name.
> > > Fixed subject format of all patches
> > > 
> > 
> > Please accept these patches.
> 
> Adding Paul to Cc, I don't think Paul has seen these, probably because
> get_maintainer.pl did not catch these hwmod files?

Yeah we didn't have top-level coverage for the data files and my 
attempts to find other in-depth reviewers has so far failed.  So just sent 
this:

http://marc.info/?l=linux-omap&m=141650684712440&w=2

Want to take it upstream?


- Paul
