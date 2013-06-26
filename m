Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3FZIyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:54:40 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:57577 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3FZIyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:54:38 -0400
Date: Wed, 26 Jun 2013 10:54:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de
Subject: Re: [GIT PULL] for tip x86/ras branch - queue for 3.11
Message-ID: <20130626085431.GA26700@gmail.com>
References: <51ca05338342dea09@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ca05338342dea09@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:
> 
>   Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce-bitmap-comment
> 
> for you to fetch changes up to 0644414e62561f0ba1bea7c5ba6a94cc50dac3e3:
> 
>   mce: acpi/apei: Add comments to clarify usage of the various bitfields in the MCA subsystem (2013-06-25 13:53:27 -0700)
> 
> ----------------------------------------------------------------
> Better comments so we understand our existing machine check
> bank bitmaps - prelude to adding another bitmap soon.
> 
> ----------------------------------------------------------------
> Naveen N. Rao (1):
>       mce: acpi/apei: Add comments to clarify usage of the various bitfields in the MCA subsystem
> 
>  arch/x86/kernel/cpu/mcheck/mce.c       |  5 ++++-
>  arch/x86/kernel/cpu/mcheck/mce_intel.c | 12 ++++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)

Pulled, thanks Tony!

	Ingo
