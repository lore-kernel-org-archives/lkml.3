Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbaGWXKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:10:36 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53870 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaGWXKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:10:35 -0400
Date: Thu, 24 Jul 2014 01:10:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
Message-ID: <20140723231032.GZ18735@two.firstfloor.org>
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
 <8738drrcxp.fsf@tassilo.jf.intel.com>
 <CALCETrWKQgnZfNmcQcROc1rOuoks7=P6VjGvwoE3aP4jTTgC0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWKQgnZfNmcQcROc1rOuoks7=P6VjGvwoE3aP4jTTgC0A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that, other than broadcast MCEs, #MC that hits in kernel mode
> is non-recoverable, or at least can't safely be recovered.  (There's a
> separate APIC interrupt for recoverable errors, I think, but that's a
> much saner interface.)

There are multiple valid cases where #MC can return.

-Andi
