Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3I3QrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:47:10 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41207 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3I3QrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:47:08 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arm Linux <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] nohz full: drop 64-bit requirement, enable ARM support v2
References: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
Date: Mon, 30 Sep 2013 09:47:04 -0700
In-Reply-To: <1380550012-7321-1-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Mon, 30 Sep 2013 16:06:49 +0200")
Message-ID: <87li2ejlyv.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> Hi Kevin,
>
> Your patchset was fine but I just did a second round. Namely I did the following changes:
>
> * Drop the 64 bits dependency after we settle the new dependency on HAVE_VIRT_CPU_ACCOUNTING_GEN
> and not before. This way we don't have a middle state that loose the dependency in the middle of
> the patchset. Probablyt no big deal but it looks more natural this way.
>
> * Refined a few changelogs.
>
> If you're ok I'll send a pull request to Ingo.

Looks good to me, thanks.

Kevin

> Kevin Hilman (3):
>   vtime: Add HAVE_VIRT_CPU_ACCOUNTING_GEN Kconfig
>   nohz: Drop generic vtime obsolete dependency on CONFIG_64BIT
>   ARM: Kconfig: allow full nohz CPU accounting
>
>  arch/Kconfig        | 12 ++++++++++++
>  arch/arm/Kconfig    |  1 +
>  init/Kconfig        |  3 ++-
>  kernel/time/Kconfig |  2 +-
>  4 files changed, 16 insertions(+), 2 deletions(-)
