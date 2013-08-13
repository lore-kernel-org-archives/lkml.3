Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab3HMWRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:17:43 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52659 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3HMWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:17:41 -0400
From: Kevin Hilman <khilman@linaro.org>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: Re: [GIT PULL v2] msm cleanups for v3.12
References: <1375909096-22088-1-git-send-email-davidb@codeaurora.org>
	<1375916792-24408-1-git-send-email-davidb@codeaurora.org>
Date: Tue, 13 Aug 2013 15:17:37 -0700
In-Reply-To: <1375916792-24408-1-git-send-email-davidb@codeaurora.org> (David
	Brown's message of "Wed, 7 Aug 2013 16:06:32 -0700")
Message-ID: <87eh9xgrr2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brown <davidb@codeaurora.org> writes:

> The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:
>
>   Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-cleanup3-for-3.12
>
> for you to fetch changes up to 3294a7e7c3a55bb4eb9d98b0af5643a7ea44afe1:
>
>   ARM: msm: Only compile io.c on platforms that use it (2013-08-06 11:18:04 -0700)
>
> ----------------------------------------------------------------
> General cleanups for MSM for 3.12
>
> This is a series of cleanups to the MSM code.  These are a healthy
> start to bringing the MSM code closer to the state of current ARM code
> and getting more of it ready for conversion to devicetree.

Pulled.

Thanks for the nice cleanups and getting closer to multi-platform
support.

Kevin
