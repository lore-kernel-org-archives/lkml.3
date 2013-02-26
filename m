Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab3BZXAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:00:16 -0500
Received: from p3plsmtpa11-03.prod.phx3.secureserver.net ([68.178.252.104]:39937
	"EHLO p3plsmtpa11-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828Ab3BZXAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:00:14 -0500
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2013 18:00:14 EST
Date: Tue, 26 Feb 2013 15:52:05 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: herbert@gondor.hengli.com.au, dmitry.kasatkin@intel.com,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: crypto: omap-sham, omap-aes and
 dma_request_slave_channel_compat()
Message-ID: <20130226225205.GA13338@animalcreek.com>
References: <512D00BE.8090204@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512D00BE.8090204@canonical.com>
Organization: Animal Creek Technologies, Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing more people & lists.]

On Tue, Feb 26, 2013 at 11:36:46AM -0700, Tim Gardner wrote:
> Whats up with commits 0e87e73f4abe1ada69cf780fe2550c6361a1b53b and
> b4b87a934c30fb91cbdd18ae028acdc361e1cf0f. As far as I can tell,
> dma_request_slave_channel_compat() does not exist in 3.9 as of
> 52caa59ed335616c5254adff7911465a57ed9f14, nor does it exist in
> linux-next as of Feb 26. Am I just being dense ?

Yeah, order got a little messed up.  The problem is known and the
sub-thread talking about it starts about here:

	http://www.spinics.net/lists/arm-kernel/msg225241.html

with the conclusion (AFAICT) that Vinod is to push it:

	http://www.spinics.net/lists/arm-kernel/msg226062.html

> Reverting those 2 commits at least allows the compile complete.

When the dependencies are sorted out, will you revert the revert
or do I need to do something?

Mark
--
