Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaBYVd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:33:59 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53460 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBYVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:33:58 -0500
Date: Tue, 25 Feb 2014 13:33:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andrey Panin <pazke@donpac.ru>,
        David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: RFC: Removing Visual Workstation and NUMAQ
Message-ID: <20140225213353.GA9980@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <530CFD6C.7040705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530CFD6C.7040705@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022521-8236-0000-0000-0000002AB816
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 12:30:36PM -0800, H. Peter Anvin wrote:
> I would like to remove Visual Workstation and NUMAQ from the x86 kernel.
>  This removes a fair bit of code which from the current looks is only
> being made to suffer general patches:
> 
> Visual Workstation:
> 
>  Documentation/sgi-visws.txt            |  13 -
>  MAINTAINERS                            |   7 -
>  arch/x86/Kconfig                       |  13 -
>  arch/x86/include/asm/visws/cobalt.h    | 127 -----
>  arch/x86/include/asm/visws/lithium.h   |  53 --
>  arch/x86/include/asm/visws/piix4.h     | 107 ----
>  arch/x86/include/asm/visws/sgivw.h     |   5 -
>  arch/x86/pci/Makefile                  |   2 -
>  arch/x86/pci/visws.c                   |  87 ----
>  arch/x86/platform/Makefile             |   1 -
>  arch/x86/platform/visws/Makefile       |   1 -
>  arch/x86/platform/visws/visws_quirks.c | 608 -----------------------
>  12 files changed, 1024 deletions(-)
> 
> NUMAQ:
> 
>  arch/x86/include/asm/numaq.h    | 171 ----------
>  arch/x86/kernel/apic/Makefile   |   1 -
>  arch/x86/kernel/apic/numaq_32.c | 524 ------------------------------
>  arch/x86/pci/Makefile           |   1 -
>  arch/x86/pci/numaq_32.c         | 165 ----------
>  5 files changed, 862 deletions(-)
> 
> 
> If there still are people who care about these platforms, please speak up.

>From a NUMAQ viewpoint:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul

