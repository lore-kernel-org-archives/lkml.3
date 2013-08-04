Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3HDU1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 16:27:07 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46364 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3HDU1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 16:27:05 -0400
Date: Sun, 4 Aug 2013 13:27:11 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [GIT PULL] msm gpio fixes for 3.11
Message-ID: <20130804202711.GC15602@quad.lixom.net>
References: <1374876322-2222-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374876322-2222-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 03:05:22PM -0700, David Brown wrote:
> The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:
> 
>   Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-3.11-fix1
> 
> for you to fetch changes up to 8fd62389a778c902c7e8532594ea924bbaf465e8:
> 
>   ARM: msm: Consolidate gpiomux for older architectures (2013-07-26 14:55:38 -0700)
> 
> ----------------------------------------------------------------
> Fixes for MSM for 3.11
> 
> Two small fixes for MSM.
> 
> The first fixes the a gpio controller register address.  I didn't see
> any acks from the devicetree maintainers, so I've copied them on this
> pull request.  The change itself is minor, and just to the register
> address.
> 
> The second change removes the gpiomux V1 code from MSM.  This was
> breaking compilation for some of the targets.

I'm guessing the second breakage was nothing new, but who am I to turn away
code removal even during -rc. :)


Pulled.


-Olof


