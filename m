Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3FOB0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:26:13 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34344 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3FOB0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:26:11 -0400
Date: Fri, 14 Jun 2013 18:26:17 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 2/3] msm fixes for 3.11
Message-ID: <20130615012617.GU18124@quad.lixom.net>
References: <1371232615-30731-1-git-send-email-davidb@codeaurora.org>
 <1371232615-30731-4-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371232615-30731-4-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:56:55AM -0700, David Brown wrote:
> The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
> 
>   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-for-3.11
> 
> for you to fetch changes up to 7ba655fc965b073292349fa49fb9d16d701185bc:
> 
>   gpio: msm-v1: Remove errant __devinit to fix compile (2013-06-12 14:49:06 -0700)
> 
> ----------------------------------------------------------------
> Some minor fixes for MSM for 3.11
> 
> I don't expect these to be necessary for stable, since the fixes are
> to recently added code.  The strncpy fix is only in debug code that
> isn't normally compiled or used (and is being removed in upcoming
> patches).
> 
> ----------------------------------------------------------------
> Chen Gang (1):
>       arch: arm: mach-msm: using strlcpy instead of strncpy
> 
> Stephen Boyd (3):
>       ARM: dts: msm: Fix bad register addresses

Hmm. I see that the msm-hsuart device nodes completely lack reg entries. That's
considerably more important to fix than the cosmetic unit address that's not
even needed unless two nodes happen to have the same name.

I ended up pulling this in underneath of the cleanup branch to resolve the
add/change conflicts there. 

-Olof
