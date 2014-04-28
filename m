Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaD1TyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:54:09 -0400
Received: from one.firstfloor.org ([193.170.194.197]:50469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaD1TyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:54:05 -0400
Date: Mon, 28 Apr 2014 19:27:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Moskyto Matejka <mq@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Updated asmlinkage patch v2
Message-ID: <20140428172731.GA2382@two.firstfloor.org>
References: <CA+55aFwYRGV65DsK4kBcdt-6PP1EY-3dOE=WUOhG=G5hcXYnVg@mail.gmail.com>
 <20140428151721.GE2641@moskyto.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428151721.GE2641@moskyto.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW some of the functions have already lost their asmlinkage, see
> commit 8783dd3a37a5853689e1a8fa728827a50905b912 ("irqchip: Remove
> asmlinkage from static functions") in torvalds tree and also recent
> thread https://lkml.org/lkml/2014/4/16/453 ("[PATCH] crypto:
> sha{256,512}_ssse3 - remove asmlinkage from static functions"), both of
> them because "it issues warnings".

I'll resend the changes.

Not sure which tree it should go through. Peter?

-Andi
