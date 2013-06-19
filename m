Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab3FSL5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:57:21 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33617 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934052Ab3FSL5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:57:17 -0400
Date: Wed, 19 Jun 2013 13:57:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>
Subject: Re: [GIT PULL] Some error injection fixes to queue for 3.11
Message-ID: <20130619115702.GC10599@gmail.com>
References: <51b20612239358173f@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b20612239358173f@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:
> 
>   Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-einj
> 
> for you to fetch changes up to ace3647afb3eca214f6da5d653ad116ff77545b6:
> 
>   ACPI/APEI: Update einj documentation for param1/param2 (2013-06-06 15:28:11 -0700)
> 
> ----------------------------------------------------------------
> Miscellaneous fixes for ACPI EINJ (error injection) code.
> 
> ----------------------------------------------------------------
> Chen Gong (2):
>       ACPI/APEI: Add parameter check before error injection
>       ACPI/APEI: Update einj documentation for param1/param2
> 
> Wei Yongjun (1):
>       ACPI, APEI, EINJ: Fix error return code in einj_init()
> 
>  Documentation/acpi/apei/einj.txt |  9 +++++++--
>  drivers/acpi/apei/einj.c         | 39 ++++++++++++++++++++++++++++++++++++---
>  kernel/resource.c                |  1 +
>  3 files changed, 44 insertions(+), 5 deletions(-)

Pulled, thanks Tony!

Len, are you fine with this route [tip:x86/ras tree] for the 
drivers/acpi/apei/einj.c changes?

Thanks,

	Ingo
