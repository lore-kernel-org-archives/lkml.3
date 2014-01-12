Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaALRmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:42:08 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54568 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaALRmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:42:07 -0500
Date: Sun, 12 Jan 2014 18:42:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@suse.de>
Cc: x86-ml <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] RAS for 3.14, p2 (updated)
Message-ID: <20140112174202.GB25449@gmail.com>
References: <20131222131629.GA32701@pd.tnic>
 <20140112143403.GA3655@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140112143403.GA3655@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@suse.de> wrote:

> On Sun, Dec 22, 2013 at 02:16:29PM +0100, Borislav Petkov wrote:
> > Hi guys,
> > 
> > this is a second set of smallish stuff for 3.14.
> 
> Ok, here's an updated one as I see you haven't pulled yet. Please pull.
> 
> The following changes since commit 42139eb356e3384759ca143ae04d82376346eb4c:
> 
>   ACPI, eMCA: Combine eMCA/EDAC event reporting priority (2013-12-11 19:04:37 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_for_3.14_p2
> 
> for you to fetch changes up to 4f75d8412792777a314ac5c1393a9ed43d695fd1:
> 
>   x86, mce: Fix mce_start_timer semantics (2014-01-12 15:22:25 +0100)
> 
> ----------------------------------------------------------------
> SCI reporting for other error types not only correctable ones
> + APEI GHES cleanups
> + mce timer fix
> 
> ----------------------------------------------------------------
> Borislav Petkov (1):
>       x86, mce: Fix mce_start_timer semantics
> 
> Chen, Gong (3):
>       ACPI, APEI, GHES: Do not report only correctable errors with SCI
>       ACPI, APEI: Cleanup alignment-aware accesses
>       ACPI, APEI, GHES: Cleanup ghes memory error handling
> 
>  arch/x86/kernel/cpu/mcheck/mce-apei.c | 14 +++++++++----
>  arch/x86/kernel/cpu/mcheck/mce.c      |  8 +++----
>  drivers/acpi/apei/apei-base.c         |  4 ++--
>  drivers/acpi/apei/einj.c              | 19 ++++++++---------
>  drivers/acpi/apei/erst.c              |  2 +-
>  drivers/acpi/apei/ghes.c              | 39 +++++++++++++++++++----------------
>  6 files changed, 47 insertions(+), 39 deletions(-)

Pulled into tip:x86/ras, thanks Boris!

	Ingo
