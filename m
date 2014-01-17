Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaAQJs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:48:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56104 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbaAQJsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:48:23 -0500
Date: Fri, 17 Jan 2014 09:48:19 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Daniel Matuschek <daniel@matuschek.net>
Cc: alsa-devel@alsa-project.org, Dimitris.Papastamos@wolfsonmicro.com,
        tiwai@suse.de, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        perex@perex.cz, broonie@kernel.org
Subject: Re: [PATCH] ASoC: wm8804: Allow control of master clock divider in
	PLL generation
Message-ID: <20140117094819.GA2826@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 08:34:10PM +0100, Daniel Matuschek wrote:
> WM8804 can run with PLL frequencies of 256xfs and 128xfs for
> most sample rates. At 192kHz only 128xfs is supported. The
> existing driver selects 128xfs automatically for some lower
> samples rates. By using an additional mclk_div divider, it
> is now possible to control the behaviour. This allows using
> 256xfs PLL frequency on all sample rates up to 96kHz. It
> should allow lower jitter and better signal quality. The
> behavior has to be controlled by the sound card driver,
> because some sample frequency share the same setting. e.g.
> 192kHz and 96kHz use 24.576MHz master clock. The only
> difference is the MCLK divider.
> 
> Signed-off-by: Daniel Matuschek <daniel@matuschek.net>

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>


Sorry about the slight delay travelling with limited internet at
the mo.

Thanks,
Charles
