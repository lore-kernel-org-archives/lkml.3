Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaDANQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:16:00 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43407 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaDANP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:15:56 -0400
Date: Tue, 1 Apr 2014 15:15:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] RAS - fix CMCI storm code
Message-ID: <20140401131546.GA7024@gmail.com>
References: <5339fcbc25587e4b8d@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5339fcbc25587e4b8d@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit b098d6726bbfb94c06d6e1097466187afddae61f:
> 
>   Linux 3.14-rc8 (2014-03-24 19:31:17 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-cmci-storm
> 
> for you to fetch changes up to 27f6c573e0f77f7d1cc907c1494c99a61e48b7d8:
> 
>   x86, CMCI: Add proper detection of end of CMCI storms (2014-03-28 13:40:16 -0700)
> 
> ----------------------------------------------------------------
> Fix the code to tell when a CMCI storm ends by actually
> looking at the machine check banks when we poll while
> interrupts are disabled.
> 
> ----------------------------------------------------------------
> Chen, Gong (1):
>       x86, CMCI: Add proper detection of end of CMCI storms
> 
>  arch/x86/kernel/cpu/mcheck/mce.c       | 18 +++++++++++++++++-
>  arch/x86/kernel/cpu/mcheck/mce_intel.c | 19 ++++++++++++++++++-
>  2 files changed, 35 insertions(+), 2 deletions(-)

Pulled, thanks Tony!

	Ingo
