Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859Ab3JQVva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:51:30 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55690 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762344Ab3JQVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:51:29 -0400
From: Kevin Hilman <khilman@linaro.org>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [GIT PULL] msm cleanups for v3.13
References: <1381954617-2431-1-git-send-email-davidb@codeaurora.org>
Date: Thu, 17 Oct 2013 14:51:22 -0700
In-Reply-To: <1381954617-2431-1-git-send-email-davidb@codeaurora.org> (David
	Brown's message of "Wed, 16 Oct 2013 13:16:57 -0700")
Message-ID: <87fvrz1s85.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brown <davidb@codeaurora.org> writes:

> The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:
>
>   Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-cleanup-for-3.13
>
> for you to fetch changes up to 81cf1e061d001fab44dbaa85fc4fbfb6da6713a1:
>
>   ARM: msm: Rename msm devicetrees to have standard 'qcom' prefix (2013-09-25 13:02:56 -0700)
>
> ----------------------------------------------------------------
> General cleanups for MSM for 3.13
>
> Some small cleanups for MSM.  Removes extraneous irq definitions that
> aren't used on DT targets, moves the single existing board file to
> board-dt.c in antipication of additional targets, and renames the
> existing DT files to have a common 'qcom' prefix.
>
> ----------------------------------------------------------------

Pulled into next/cleanup,

Thanks,

Kevin
