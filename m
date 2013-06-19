Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3FSMwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:52:49 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64953 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3FSMwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:52:47 -0400
Date: Wed, 19 Jun 2013 14:52:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619125243.GD11209@gmail.com>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371491416-11037-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> Hi all,
> 
> this is just a snapshot of the current state of affairs. The patchset
> starts to boot successfully on real hardware now but we're far away from
> the coverage we'd like to have before we even consider upstreaming it.

Looks pretty clean.

> And yes, considering the sick f*ck EFI is, we're keeping the 1:1 mapping
> optional and off by default (you need to boot with "efi=1:1_map" to
> enable it).

I hope making it a weird boot option is not the end plan, there's little 
point in _not_ enabling 1:1 mappings by default eventually: the 1:1 
mapping is supposed to emulate a "Windows compatible" EFI environment 
better and is expected to work around certain EFI runtime crashes.

Thanks,

	Ingo
