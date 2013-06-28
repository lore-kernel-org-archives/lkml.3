Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3F1JLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:11:04 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:62411 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3F1JLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:11:01 -0400
Date: Fri, 28 Jun 2013 11:10:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] Another mce cleanup for the 3.11 queue
Message-ID: <20130628091057.GA27872@gmail.com>
References: <51ccb0a019950f07cd@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ccb0a019950f07cd@agluck-desk.sc.intel.com>
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
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce
> 
> for you to fetch changes up to 33d7885b594e169256daef652e8d3527b2298e75:
> 
>   x86/mce: Update MCE severity condition check (2013-06-27 13:45:52 -0700)
> 
> ----------------------------------------------------------------
> Changes to simplify the SDM mean that we can also simplify
> the code for SRAR (software recoverable action required) errors.
> 
> ----------------------------------------------------------------
> Chen Gong (1):
>       x86/mce: Update MCE severity condition check
> 
>  arch/x86/kernel/cpu/mcheck/mce-severity.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)

Pulled, thanks Tony!

	Ingo
