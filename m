Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3HOIIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:08:11 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51994 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3HOIIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 04:08:04 -0400
Date: Thu, 15 Aug 2013 10:07:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.12
Message-ID: <20130815080759.GA29917@gmail.com>
References: <20130814160836.GD9158@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814160836.GD9158@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Hi guys,
> 
> this is all 3.12 material, please pull.
> 
> Thanks!
> 
> The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:
> 
>   Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.12
> 
> for you to fetch changes up to 75a9551f2b3792686df25501f248d1de92d5da0f:
> 
>   cpc925_edac: Use proper array termination (2013-08-14 12:46:46 +0200)
> 
> ----------------------------------------------------------------
> An amd64_edac fix for single channel configurations + trivial cleanups
> courtesy of Jingoo Han.
> 
> ----------------------------------------------------------------
> Borislav Petkov (1):
>       amd64_edac: Fix single-channel setups
> 
> Jingoo Han (4):
>       EDAC: Replace strict_strtol() with kstrtol()
>       i3200_edac: Make a local function static
>       x38_edac: Make a local function static
>       cpc925_edac: Use proper array termination
> 
>  drivers/edac/amd64_edac.c    | 9 ++++++++-
>  drivers/edac/cpc925_edac.c   | 2 +-
>  drivers/edac/edac_mc_sysfs.c | 6 ++++--
>  drivers/edac/i3200_edac.c    | 3 +--
>  drivers/edac/x38_edac.c      | 3 +--
>  5 files changed, 15 insertions(+), 8 deletions(-)

Pulled, thanks Boris!

	Ingo
