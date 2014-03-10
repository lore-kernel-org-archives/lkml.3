Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaCJRF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:05:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39446 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbaCJRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:05:27 -0400
Date: Mon, 10 Mar 2014 17:05:24 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, patches@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5102: Mark register 0x19 readable
Message-ID: <20140310170524.GN8570@opensource.wolfsonmicro.com>
References: <1394468977-23149-1-git-send-email-broonie@kernel.org> <20140310163811.GA16697@lee--X1> <20140310164904.GO28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310164904.GO28112@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:49:04PM +0000, Mark Brown wrote:
> On Mon, Mar 10, 2014 at 04:38:11PM +0000, Lee Jones wrote:
> 
> > Can we have a #define for these please?
> 
> It'd be nice but you'd need to ask the Wolfson guys to tell us what it's
> called, all the information I have is the read in the driver source.
> Meanwile we've got a bug.

WRITE_SEQUENCER_CTRL_3, seems we should add that in since it is
required for that 5102 boot stuff. Slightly confused as to how
that ever worked without the register being readable, but guess
it has been a while since I have fired up 5102 on mainline.

Thanks,
Charles


