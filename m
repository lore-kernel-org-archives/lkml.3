Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3JaJhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:37:23 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38330 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3JaJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:37:22 -0400
Date: Thu, 31 Oct 2013 10:37:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Move drivers/acpi/apei/cper.c to drivers/firmware/efi/
Message-ID: <20131031093718.GA9453@gmail.com>
References: <52700d2920076a466d@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52700d2920076a466d@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit 56507694de3453076d73e0e9813349586ee67e59:
> 
>   EDAC, GHES: Update ghes error record info (2013-10-23 10:11:00 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-move-cper
> 
> for you to fetch changes up to c57a801195153e111bcd712680a718cf101b6d1f:
> 
>   Move cper.c from drivers/acpi/apei to drivers/firmware/efi (2013-10-29 09:23:38 -0700)
> 
> ----------------------------------------------------------------
> cper.c implements UEFI Appendix N "Common Platform Error Record"
> handling. Move it to drivers/firmware/efi/cper.c to reflect this
> heritage.
> 
> ----------------------------------------------------------------
> Tony Luck (1):
>       Move cper.c from drivers/acpi/apei to drivers/firmware/efi
> 
>  drivers/acpi/Kconfig                       | 4 +++-
>  drivers/acpi/apei/Kconfig                  | 2 ++
>  drivers/acpi/apei/Makefile                 | 2 +-
>  drivers/firmware/efi/Kconfig               | 3 +++
>  drivers/firmware/efi/Makefile              | 1 +
>  drivers/{acpi/apei => firmware/efi}/cper.c | 0
>  6 files changed, 10 insertions(+), 2 deletions(-)
>  rename drivers/{acpi/apei => firmware/efi}/cper.c (100%)

Hm, it's not very well tested:

  drivers/firmware/efi/Kconfig:41: syntax error
  drivers/firmware/efi/Kconfig:40: unknown option "defbool"

Thanks,

	Ingo
