Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031182AbaLLRV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:21:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47350 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030845AbaLLRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:21:26 -0500
Date: Fri, 12 Dec 2014 18:21:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
Message-ID: <20141212172124.GB7760@amd>
References: <alpine.DEB.2.11.1412091504490.16275@nanos>
 <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
 <5488A203.7000600@linux.intel.com>
 <CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com>
 <5488AF8D.5070702@linux.intel.com>
 <20141211061935.GA5059@gmail.com>
 <548A147E.1020507@linux.intel.com>
 <20141212123048.GA31711@amd>
 <548B0E14.6040409@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548B0E14.6040409@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +	  If unsure, say Y.

"If you bought your cpu in 2014 or earlier, say N here".

:-)

> -Note: Currently no hardware with MPX ISA is available but it is always
> +Note: As of December 2014, no hardware with MPX is available but it is
>  possible to use SDE (Intel(R) Software Development Emulator) instead, which
>  can be downloaded from
>  http://software.intel.com/en-us/articles/intel-software-development-emulator

Ack.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
