Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaDOUms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:42:48 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35641 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753925AbaDOUmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:42:46 -0400
Date: Tue, 15 Apr 2014 21:42:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] mmc: sdhci: defer probing on
	regulator_get_optional() failures
Message-ID: <20140415204201.GW24070@n2100.arm.linux.org.uk>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org> <1397526163-20126-4-git-send-email-abrestic@chromium.org> <534D7A5D.9090707@wwwdotorg.org> <CAL1qeaEGpz-9rOtp4fAHFz8KG2fCscFsqu1tbi2d9mxTM8yHQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1qeaEGpz-9rOtp4fAHFz8KG2fCscFsqu1tbi2d9mxTM8yHQQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:59:37PM -0700, Andrew Bresticker wrote:
> I believe the crash Alex is seeing is due to a race between tearing
> down the sdhci driver on probe deferral and the card-detect IRQ.
> Looking at it now.

You probably want to check out my massive sdhci patch set posted a
while back.

http://www.spinics.net/lists/linux-mmc/msg25031.html

I'll re-post it again soon (probably next week as I'm rather busy),
updated to v3.15-rc1.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
