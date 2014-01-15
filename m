Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaAOGli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:41:38 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51641 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaAOGlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:41:36 -0500
Date: Wed, 15 Jan 2014 07:41:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksources: 3.13 fixes
Message-ID: <20140115064132.GA12484@gmail.com>
References: <52C14E45.5040403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C14E45.5040403@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> 
> Hi Thomas and Ingo,
> 
> here is a pull request for a single fix for 3.13. It is based on the
> latest timers/urgent update.
> 
>  * Soren Brinkmann fixed the cadence_ttc driver where a call to
> clk_get_rate happens in an interrupt context. More precisely in an
> IPI when the broadcast timer is initialized for each cpu in the
> cpuidle driver
> 
> Thanks
>   -- Daniel
> 
> The following changes since commit b0031f227e47919797dc0e1c1990f3ef151ff0cc:
> 
>   Merge tag 's2mps11-build' of
> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
> (2013-12-17 12:57:36 -0800)
> 
> are available in the git repository at:
> 
> 
>   git://git.linaro.org/people/daniel.lezcano/linux.git
> clockevents/3.13-fixes
> 
> for you to fetch changes up to c1dcc927dae01dfd4904ee82ce2c00b50eab6dc3:
> 
>   clocksource: cadence_ttc: Fix mutex taken inside interrupt context
> (2013-12-30 11:32:24 +0100)
> 
> ----------------------------------------------------------------
> Soren Brinkmann (1):
>       clocksource: cadence_ttc: Fix mutex taken inside interrupt context
> 
>  drivers/clocksource/cadence_ttc_timer.c |   21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

Pulled into tip:timers/urgent, thanks Daniel!

	Ingo
