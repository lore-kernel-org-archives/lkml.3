Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab3A1SoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:44:24 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:64335 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3A1SoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:44:22 -0500
Date: Mon, 28 Jan 2013 19:44:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v3 02/71] ARC: Build system: Makefiles, Kconfig, Linker
	script
Message-ID: <20130128184419.GA24853@merkur.ravnborg.org>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-3-git-send-email-vgupta@synopsys.com> <51061AD0.4020200@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51061AD0.4020200@synopsys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 11:59:36AM +0530, Vineet Gupta wrote:
> Hi Sam,
> 
> On Thursday 24 January 2013 04:20 PM, Vineet Gupta wrote:
> > Arnd in his review pointed out that arch Kconfig organisation has several
> > deficiencies:
> > 
> > * Build time entries for things which can be runtime extracted from DT
> >   (e.g. SDRAM size, core clk frequency..)
> > * Not multi-platform-image-build friendly (choice .. endchoice constructs)
> > * cpu variants support (750/770) is exclusive.
> > 
> > The first 2 have been fixed in subsequent patches.
> > Due to the nature of the 750 and 770, it is not possible to build for
> > both together, w/o special runtime glue code which would hurt
> > performance.
> > 
> > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Sam Ravnborg <sam@ravnborg.org>

Looks good - all former comments addressed, and nothing were jumping
into my eyes now.
Many existing architectures looks worse from the build stuff perspective...

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
