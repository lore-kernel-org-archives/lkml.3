Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaKLOKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:10:55 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46195 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaKLOKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:10:54 -0500
Date: Wed, 12 Nov 2014 15:10:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@suse.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: Two minor cleanups for 3.19
Message-ID: <20141112141048.GA1916@gmail.com>
References: <20141111184642.GN31490@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111184642.GN31490@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@suse.de> wrote:

> Hi guys,
> 
> just two small cleanups which have been lying around for a while.
> 
> Please pull,
> thanks.
> 
> ---
> The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:
> 
>   Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/x86_queue_for_3.19
> 
> for you to fetch changes up to 6f9b63a0ae0d694e3d8e6f673e1e8e2638526b97:
> 
>   x86, CPU, AMD: Move K8 TLB flush filter workaround to K8 code (2014-11-11 17:58:20 +0100)
> 
> ----------------------------------------------------------------
> Two minor cleanups for the next merge window.
> 
> ----------------------------------------------------------------
> Borislav Petkov (2):
>       x86, espfix: Remove stale ptemask
>       x86, CPU, AMD: Move K8 TLB flush filter workaround to K8 code
> 
>  arch/x86/kernel/cpu/amd.c   | 23 +++++++++++------------
>  arch/x86/kernel/espfix_64.c |  3 ---
>  2 files changed, 11 insertions(+), 15 deletions(-)

Pulled, thanks Boris!

	Ingo
