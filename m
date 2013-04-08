Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190Ab3DHPms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:42:48 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51581 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936502Ab3DHPmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:42:46 -0400
Date: Mon, 8 Apr 2013 17:42:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] x86/mce - clean up cmci_rediscover()
Message-ID: <20130408154242.GA19974@gmail.com>
References: <515c953a828839e37@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515c953a828839e37@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:
> 
>   Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-cmci_rediscover
> 
> for you to fetch changes up to 7a0c819d28f5c91955854e048766d6afef7c8a3d:
> 
>   x86/mce: Rework cmci_rediscover() to play well with CPU hotplug (2013-04-02 14:04:01 -0700)
> 
> ----------------------------------------------------------------
> Clean up cmci_rediscover code to fix problems found by Dave Jones
> 
> ----------------------------------------------------------------
> Srivatsa S. Bhat (1):
>       x86/mce: Rework cmci_rediscover() to play well with CPU hotplug
> 
>  arch/x86/include/asm/mce.h             |  4 ++--
>  arch/x86/kernel/cpu/mcheck/mce.c       |  2 +-
>  arch/x86/kernel/cpu/mcheck/mce_intel.c | 25 +++++--------------------
>  3 files changed, 8 insertions(+), 23 deletions(-)

Pulled, thanks Tony!

	Ingo
