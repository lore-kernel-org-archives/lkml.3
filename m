Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaARWM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 17:12:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55162 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaARWMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 17:12:24 -0500
Date: Sat, 18 Jan 2014 23:12:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
Message-ID: <20140118221212.GB15543@pd.tnic>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
 <1390079163.25980.2.camel@x41>
 <CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 11:07:10PM +0100, Bjarke Istrup Pedersen wrote:
> I have been thinking about other solutions, but so far, I haven't been
> able to find one that solves it, so the tools build. (An option might
> be to strip it from the __KERNEL__ part, to make it smaller, but I
> don't know what difference that would make :-)

The fix is to move the userspace stuff into the uapi header and include
that header in the kernel header.

See include/linux/sched.h and many others for an example.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
