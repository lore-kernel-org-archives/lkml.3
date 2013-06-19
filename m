Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab3FSLwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:52:13 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:52982 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3FSLwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:52:12 -0400
Date: Wed, 19 Jun 2013 13:52:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, Mathias Krause <minipli@googlemail.com>,
        Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] RAS: Fix typos
Message-ID: <20130619115208.GB10599@gmail.com>
References: <20130608082844.GB13596@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130608082844.GB13596@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Hi guys,
> 
> please pull.
> 
> Thanks.
> 
> The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:
> 
>   Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_fixlet_for_3.11
> 
> for you to fetch changes up to a90936845da138209aa5dda0c84269f7482aa3cf:
> 
>   x86, mce: Fix "braodcast" typo (2013-06-05 11:59:17 +0200)
> 
> ----------------------------------------------------------------
> Fix typo in define
> 
> ----------------------------------------------------------------
> Mathias Krause (1):
>       x86, mce: Fix "braodcast" typo
> 
>  arch/x86/include/asm/mce.h              | 2 +-
>  arch/x86/kernel/cpu/mcheck/mce-inject.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Pulled, thanks Boris!

	Ingo
