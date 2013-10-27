Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3J0HAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 03:00:39 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:46678 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3J0HAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 03:00:38 -0400
Date: Sun, 27 Oct 2013 08:00:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
Message-ID: <20131027070035.GB28433@gmail.com>
References: <5266bc543597964da@agluck-desk.sc.intel.com>
 <52680aa01445165d7@agluck-desk.sc.intel.com>
 <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com>
 <20131026101055.GB14949@gmail.com>
 <75C2D580-105E-4B49-80D4-E047C1530FC2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75C2D580-105E-4B49-80D4-E047C1530FC2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@gmail.com> wrote:

> > Hm, I'm not sure we should move something named after a hardware 
> > feature into lib/. It's not really generic C library functionality,
>
> 
> Not a hardware feature. CPER stands for Common Platform Error Record 
> from the UEFI standard. [...]

By all means UEFI can be considered platform dependent at the moment:

  comet:~/tip> git grep -i uefi arch/arm/
  comet:~/tip> git grep -i uefi arch/arm64/
  comet:~/tip> git grep -i uefi arch/powerpc/
  comet:~/tip> git grep -i uefi arch/mips/
  comet:~/tip> 

If a committee says that a name of some standard is 'common platform' does 
not make it so. lib/ is mostly kept for mathematical, C-library alike 
functionality you see in CS textbooks.

> As Chen Gong points out, drivers/acpi isn't the right place ... so if 
> not lib/ ... then where?

drivers/uefi/?

Thanks,

	Ingo
