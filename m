Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbbAOKbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:31:52 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51271 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbAOKbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:31:50 -0500
Date: Thu, 15 Jan 2015 11:31:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>, linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [GIT PULL] RAS update for 3.20
Message-ID: <20150115103146.GB1698@gmail.com>
References: <20150113120713.GA5784@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3299AD99@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3299AD99@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> > Nothing special this time, just an error messages improvement from Andy
> > and a cleanup from me.
> 
> Also this APEI change that hasn't seen much commentary since Tomas Nowicki pointed
> out that v1 had cluttered up the APEI code with some x86-ism after he'd spent time
> cleaning it up - so v2 addressed that by moving the x86 code out into arch/x86.
> 
> -Tony
> 
> The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:
> 
>   Linux 3.18 (2014-12-07 14:21:05 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-einj-mmcfg
> 
> for you to fetch changes up to d91525eb8ee6a622ce476955fe1a2530ade87c83:
> 
>   ACPI, EINJ: Enhance error injection tolerance level (2014-12-15 11:36:37 -0800)
> 
> ----------------------------------------------------------------
> When checking addresses in APEI action entries for validity, allow
> access the mmcfg space - some error injection functions need to do
> this.
> 
> ----------------------------------------------------------------
> Chen, Gong (1):
>       ACPI, EINJ: Enhance error injection tolerance level
> 
>  arch/x86/pci/mmconfig-shared.c | 28 ++++++++++++++++++++++++++++
>  drivers/acpi/apei/apei-base.c  | 32 ++++++++++++++++++++++++++------
>  2 files changed, 54 insertions(+), 6 deletions(-)

Pulled into tip:x86/ras, thanks Tony!

	Ingo
