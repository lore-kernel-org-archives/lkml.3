Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3DODtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:49:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46572 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab3DODtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:49:04 -0400
Date: Sun, 14 Apr 2013 20:49:05 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca
Subject: Re: [GIT PULL] msm core for 3.10
Message-ID: <20130415034905.GC10949@quad.lixom.net>
References: <8ya7gk7qsnp.fsf@huya.qualcomm.com>
 <8yazjx3pdz0.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yazjx3pdz0.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 12, 2013 at 03:43:15PM -0700, David Brown wrote:
> The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:
> 
>   Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-core-3.10
> 
> for you to fetch changes up to e25e3d1fef2c57e49aef64535341c15fe2b29b4a:
> 
>   ARM: msm: Wait for timer clear to complete (2013-03-22 10:46:16 -0700)
> 
> ----------------------------------------------------------------
> Patches for MSM core
> 
> These patches are changes to the MSM timer code that will be for
> upcoming targets, including a generalization of the binding and
> preventing a missing timer interrupt.
> 
> ----------------------------------------------------------------
> Stephen Boyd (2):
>       ARM: msm: Rework timer binding to be more general
>       ARM: msm: Wait for timer clear to complete
> 
>  .../devicetree/bindings/arm/msm/timer.txt          |  41 ++++----
>  arch/arm/boot/dts/msm8660-surf.dts                 |  20 ++--
>  arch/arm/boot/dts/msm8960-cdp.dts                  |  22 ++---
>  arch/arm/mach-msm/timer.c                          | 110 ++++++++++-----------
>  4 files changed, 86 insertions(+), 107 deletions(-)

I didn't see either of the device tree maintainers cc:d on the bindings
update, nor an ack from them. It looks reasonable enough to me, but I
also do know that in your private downstream tree you have a lot of new
bindings. Please make sure these go through proper review channels as
you start to upstream them; i.e. Grant Likely and Rob Herring should
either merge or ack them.

I've cc:d Rob and Grant on this reply and I'll merge it for now but to avoid
delays in getting your code merged in the future please make sure they are in
the loop from the beginning.


Thanks,

-Olof
