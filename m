Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3HLRwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:52:53 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33635 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3HLRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:52:45 -0400
Date: Mon, 12 Aug 2013 19:52:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] x86/mce fix to queue for 3.12
Message-ID: <20130812175241.GA18691@gmail.com>
References: <51ffe0bd109866a44a@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ffe0bd109866a44a@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:
> 
>   Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce-f-bit
> 
> for you to fetch changes up to 0ca06c0857aee11911f91621db14498496f2c2cd:
> 
>   x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' errors (2013-08-05 10:09:40 -0700)
> 
> ----------------------------------------------------------------
> Bit 12 may or may not be set in MCi_STATUS.MCACOD when
> an uncorrected error is reported. Ignore it when checking
> error signatures.
> 
> ----------------------------------------------------------------
> Tony Luck (1):
>       x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' errors
> 
>  arch/x86/include/asm/mce.h | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Pulled, thanks Tony!

	Ingo
