Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaF2UNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 16:13:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44492 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbaF2UNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 16:13:12 -0400
Date: Sun, 29 Jun 2014 22:13:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan-Simon =?utf-8?Q?M=C3=B6ller?= <dl9pf@gmx.de>
Cc: pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <mcharleb@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3d3d6b847420 ("kbuild: LLVMLinux: Adapt warnings for compilation
 with clang")
Message-ID: <20140629201308.GC12943@pd.tnic>
References: <20140616130751.GD8170@pd.tnic>
 <539F0D55.31207.1DF87EFF@pageexec.freemail.hu>
 <2065274.H8oo5iWEkB@aragorn.auenland.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2065274.H8oo5iWEkB@aragorn.auenland.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 16, 2014 at 05:48:01PM +0200, Jan-Simon Möller wrote:
> Ok, let's wrap this case with 
> 
> ifeq ($(COMPILER),clang)
> ...
> endif
> 
> And we'll update the stale entries.
> 
> Patch to follow after some testing.

any progress with the testing or should we simply revert?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
