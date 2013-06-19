Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3FSNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:25:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59710 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3FSNZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:25:27 -0400
Date: Wed, 19 Jun 2013 15:25:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619132520.GB28300@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130619130434.GB24957@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 03:04:34PM +0200, Ingo Molnar wrote:
> Do we know why?

Well, according to mjg59 some Macs break if we don't give them a map
which uses high addresses.

I can imagine flipping the meaning of this option to be on by default
and "efi=no_11_map" to disable the 1:1 map for those Macs.

> A bug I suspect?

Probably. The problem is, it is very hard to debug the boot stub that
early. And of course, I can't reproduce it in qemu :(. If only I had a
hardware debugger...

> But once it works reliably we can enable it, right?

It's all the same to me - I hate EFI with passion so whatever people
agree upon, I'll do it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
