Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3CWSBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 14:01:44 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3CWSBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 14:01:43 -0400
Date: Sat, 23 Mar 2013 19:01:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/29] x86, tsx: Add a per thread transaction disable
 count
Message-ID: <20130323180142.GL20853@two.firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-13-git-send-email-andi@firstfloor.org>
 <20130323115115.GA10821@pd.tnic>
 <20130323135156.GJ20853@two.firstfloor.org>
 <20130323155256.GB10811@pd.tnic>
 <CA+55aFwim=_UjV+n6MGRCgoa3B-9RuhVF2h=munaRpZhT3Ntfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwim=_UjV+n6MGRCgoa3B-9RuhVF2h=munaRpZhT3Ntfg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That said, making it just a byte sounds more than enough. How deep
> would anybody want to nest it? Do we care?

Byte should be fine. I'll change that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
