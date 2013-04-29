Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3D2BZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 21:25:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:56177 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab3D2BZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 21:25:08 -0400
Date: Mon, 29 Apr 2013 11:25:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: kernel-hardening@lists.openwall.com
cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [kernel-hardening] Re: [PATCH 3/6] x86: kaslr: return location
 from decompress_kernel
In-Reply-To: <517AF5F2.50404@zytor.com>
Message-ID: <alpine.LRH.2.02.1304291124520.5728@tundra.namei.org>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org> <1367003005-5560-4-git-send-email-keescook@chromium.org> <517AF5F2.50404@zytor.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, H. Peter Anvin wrote:

> > +	noaslr		[X86]
> > +			Disable kernel base offset ASLR (Address Space
> > +			Layout Randomization) if built into the kernel.
> > +
> >  	noautogroup	Disable scheduler automatic task group creation.
> >  
> >  	nobats		[PPC] Do not use BATs for mapping kernel lowmem
> 
> Calling it "nokaslr" might be useful to note that it is specifically
> about the kernel.
> 

Agreed.


-- 
James Morris
<jmorris@namei.org>
