Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab3DDLck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:32:40 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:47880 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab3DDLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:32:39 -0400
Message-ID: <515D64C6.9050903@synopsys.com>
Date: Thu, 4 Apr 2013 17:02:22 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <oskar.andero@sonymobile.com>
CC: <linux-kernel@vger.kernel.org>, <masami.hiramatsu.pt@hitachi.com>,
        <davem@davemloft.net>, <anil.s.keshavamurthy@intel.com>,
        <ananth@in.ibm.com>, <radovan.lekanovic@sonymobile.com>,
        <bjorn.davidsson@sonymobile.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/4] kprobes: split blacklist into common and arch
References: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.12.197.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

On 04/03/2013 01:58 PM, oskar.andero@sonymobile.com wrote:
> Hi,
> 
> This is a slight rework of the following patches which I posted earlier:
> [PATCH] Kprobes blacklist: Conditionally add x86-specific symbols
> [PATCH] delay blacklist symbol lookup until we actually need it
> 
> This serie includes a patch that moves the architecture dependent black points
> to the arch/ directory and the x86 patch was modified to follow that patch.
> 
> -Oskar
> 
> Björn Davidsson (1):
>   kprobes: move x86-specific blacklist symbols to arch directory
> 
> Oskar Andero (2):
>   kprobes: split blacklist into common and arch
>   kprobes: replace printk with pr_-functions
> 
> Toby Collett (1):
>   kprobes: delay blacklist symbol lookup until we actually need it
> 
>  arch/arc/kernel/kprobes.c      |   3 +
>  arch/arm/kernel/kprobes.c      |   2 +
>  arch/avr32/kernel/kprobes.c    |   3 +
>  arch/ia64/kernel/kprobes.c     |   3 +
>  arch/mips/kernel/kprobes.c     |   3 +
>  arch/mn10300/kernel/kprobes.c  |   2 +
>  arch/powerpc/kernel/kprobes.c  |   3 +
>  arch/s390/kernel/kprobes.c     |   3 +
>  arch/sh/kernel/kprobes.c       |   3 +
>  arch/sparc/kernel/kprobes.c    |   3 +
>  arch/x86/kernel/kprobes/core.c |   7 ++
>  kernel/kprobes.c               | 149 ++++++++++++++++++++++++++---------------
>  12 files changed, 130 insertions(+), 54 deletions(-)
> 

For any arch changes, however trivial they might be, you need to CC the respective
maintainers, or atleast post the patches on linux-arch so we know what's going on !


Thx,
-Vineet
