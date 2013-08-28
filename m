Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3H1Itk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:49:40 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58739 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3H1Iti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:49:38 -0400
Date: Wed, 28 Aug 2013 10:49:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] amd64_edac fixlets for 3.12 queue
Message-ID: <20130828084934.GA12327@gmail.com>
References: <20130824092500.GA28945@pd.tnic>
 <20130824174246.GC28383@pd.tnic>
 <20130827133458.GD5855@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827133458.GD5855@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Ok,
> 
> here's a pull request which should go ontop of tip/x86/ras.
> 
> Please pull guys,
> thanks.
> 
> The following changes since commit c874b6ba5550b47b667ebf98f549478b4bc988a2:
> 
>   Merge tag 'edac_for_3.12' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/ras (2013-08-15 10:07:20 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_fixes_for_3.12
> 
> for you to fetch changes up to 4fc06b3171f4de92cd21bf7ab1cb0bf62f05769d:
> 
>   amd64_edac: Fix incorrect wraparounds (2013-08-27 15:00:22 +0200)
> 
> ----------------------------------------------------------------
> Two fixlets for Erratum 505 ranges and overflowing variables.
> 
> ----------------------------------------------------------------
> Aravind Gopalakrishnan (1):
>       amd64_edac: Fix incorrect wraparounds
> 
> Borislav Petkov (1):
>       amd64_edac: Correct erratum 505 range
> 
>  drivers/edac/amd64_edac.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

Pulled, thanks Boris!

	Ingo
