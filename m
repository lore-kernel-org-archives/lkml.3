Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaIIVSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:18:48 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55993 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaIIVSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:18:46 -0400
Date: Tue, 9 Sep 2014 14:09:50 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Timur Tabi <timur@tabi.org>, Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mpa@pengutronix.de
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140909210949.GA1816@Asurada>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada>
 <540F5706.1050303@tabi.org>
 <20140909195928.GA5224@Asurada>
 <540F5D29.7040309@tabi.org>
 <20140909202710.GB5224@Asurada>
 <540F6506.4060302@tabi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540F6506.4060302@tabi.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 03:37:26PM -0500, Timur Tabi wrote:
> >However, my approach doesn't need any check. The open() or pm_resume()
> >can just call clk_prepare_enable() directly. The __clk_enable() will
> >then handle the 'clk == NULL' case:
> 
> Yes, I was thinking the same thing.

Because that's following your suggestion :)

@Shengjiu
Another thing I forgot to mention is we still need a return check for
clk_prepare_enable() which isn't in the current version. And I said
"doesn't need any check" is indicating the pre-check of the call.

Thank you
Nicolin
