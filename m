Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968142Ab3DSLEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 07:04:09 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43426 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab3DSLEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 07:04:07 -0400
Date: Fri, 19 Apr 2013 13:04:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, linux-edac <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [GIT PULL] amd64_edac: Add Family 16h support
Message-ID: <20130419110403.GA30207@gmail.com>
References: <20130419110042.GC21981@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130419110042.GC21981@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Hi,
> 
> please pull the below tag to receive AMD F16h support for amd64_edac.
> 
> Thanks.
> 
> The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:
> 
>   Linux 3.9-rc7 (2013-04-14 17:45:16 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/edac_amd_f16h
> 
> for you to fetch changes up to 94c1acf2c85b03a59a42d931a94a13a76c123a62:
> 
>   amd64_edac: Add Family 16h support (2013-04-19 12:46:50 +0200)
> 
> ----------------------------------------------------------------
> Add required support for AMD F16h to amd64_edac.
> 
> ----------------------------------------------------------------
> Aravind Gopalakrishnan (1):
>       amd64_edac: Add Family 16h support
> 
>  arch/x86/kernel/amd_nb.c  |  3 ++-
>  drivers/edac/amd64_edac.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/edac/amd64_edac.h |  4 +++-
>  include/linux/pci_ids.h   |  2 ++
>  4 files changed, 71 insertions(+), 3 deletions(-)

Pulled, thanks guys!

	Ingo
