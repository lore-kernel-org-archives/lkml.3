Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbbAOKar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:30:47 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53912 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbAOKan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:30:43 -0500
Date: Thu, 15 Jan 2015 11:30:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@suse.de>
Cc: x86-ml <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] RAS update for 3.20
Message-ID: <20150115103038.GA1698@gmail.com>
References: <20150113120713.GA5784@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113120713.GA5784@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@suse.de> wrote:

> Hi guys,
> 
> please queue this for 3.20.
> 
> Thanks.
> 
> ---
> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
> 
>   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/ras_for_3.20
> 
> for you to fetch changes up to 83737691e586cd2767fa4fc87cd41251d1a49e9e:
> 
>   x86, mce: Fix sparse errors (2014-12-22 21:04:31 +0100)
> 
> ----------------------------------------------------------------
> Nothing special this time, just an error messages improvement from Andy
> and a cleanup from me.
> 
> ----------------------------------------------------------------
> Andy Lutomirski (1):
>       x86, mce: Improve timeout error messages
> 
> Borislav Petkov (1):
>       x86, mce: Fix sparse errors
> 
>  arch/x86/kernel/cpu/mcheck/mce.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)

Pulled into tip:x86/ras, thanks Boris!

	Ingo
