Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3AXNt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:49:57 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58821 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3AXNtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:49:50 -0500
Date: Thu, 24 Jan 2013 14:49:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Lance Ortiz <lance.ortiz@hp.com>
Subject: Re: [GIT PULL] Use perf/event tracing to report PCI Express advanced
 errors
Message-ID: <20130124134945.GB9715@gmail.com>
References: <50e744c134281a8f8@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50e744c134281a8f8@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
> 
>   Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-aer-trace
> 
> for you to fetch changes up to 2cced2d95961acd318e9395578a60ee424d9db80:
> 
>   aerdrv: Cleanup log output for AER (2013-01-03 14:35:41 -0800)
> 
> ----------------------------------------------------------------
> Use perf/event tracing to report PCI Express advanced errors.
> 
> ----------------------------------------------------------------
> Lance Ortiz (3):
>       aerdrv: Trace Event for PCI Express Advanced Error Reporting
>       aerdrv: Enhanced AER logging
>       aerdrv: Cleanup log output for AER
> 
>  drivers/acpi/apei/cper.c               |   19 ++++++--
>  drivers/pci/pcie/aer/aerdrv_errprint.c |   63 ++++++++++++++------------
>  include/linux/aer.h                    |    4 +-
>  include/trace/events/ras.h             |   77 ++++++++++++++++++++++++++++++++
>  4 files changed, 129 insertions(+), 34 deletions(-)
>  create mode 100644 include/trace/events/ras.h

Pulled, thanks Tony!

	Ingo
