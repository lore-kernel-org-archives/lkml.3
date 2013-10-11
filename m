Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3JKGWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:22:06 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60244 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3JKGWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:22:04 -0400
Date: Fri, 11 Oct 2013 08:21:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Peter Jones <pjones@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131011062159.GD4975@gmail.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131010173710.GA18821@fenchurch.internal.datastacks.com>
 <20131010174521.GA27218@gmail.com>
 <20131010175828.GA9065@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010175828.GA9065@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Oct 10, 2013 at 07:45:21PM +0200, Ingo Molnar wrote:
> 
> > Also, the main question would be, what is the typical value for 
> > si->lfb_depth. 32 on almost all EFI systems? All around the map? Depends 
> > on what graphics state the EFI bootloader passes us?
> 
> Microsoft require that it be 32, so in practice I suspect it'll always 
> be 32. [...]

Ok, cool - and it's a rare sight: Microsoft standing up against bloat and 
complexity.

> [...] It's possible that Itanium decides to be different.

That would be a feature!

Thanks,

	Ingo
