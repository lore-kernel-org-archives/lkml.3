Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3KKRe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:34:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab3KKRer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:34:47 -0500
Date: Mon, 11 Nov 2013 18:00:41 +0100
From: Michal Marek <mmarek@suse.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCH -v1.1] Kbuild: Ignore GREP_OPTIONS env variable
Message-ID: <20131111170041.GA18517@pobox.suse.cz>
References: <20131030160635.GE13290@pd.tnic> <527AB7D1.9080307@suse.cz> <20131111142743.GE28219@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131111142743.GE28219@pd.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 03:27:43PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> Subject: [PATCH] Kbuild: Ignore GREP_OPTIONS env variable
> 
> When building the kernel in a shell which defines GREP_OPTIONS so that
> grep behavior is modified, we can break the generation of the syscalls
> table like so:
> 
> __SYSCALL_COMMON([01;31m[K0[m[K, sys_read, sys_read)
> __SYSCALL_COMMON([01;31m[K1[m[K, sys_write, sys_write)
> __SYSCALL_COMMON([01;31m[K1[m[K0, sys_mprotect, sys_mprotect) ...

The email had literal escape sequences and git am preserved them, so git
show displayed red zeros and onces. That was quite scary, so I replaced
the escape character with ^[.

Anyway, applied to kbuild.git#kbuild now.

Michal
