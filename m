Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaGaRU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:20:27 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:34103 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaGaRUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:20:24 -0400
Date: Thu, 31 Jul 2014 19:20:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        linux-arch <linux-arch@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] x86: two-phase syscall tracing and seccomp
 fastpath
Message-ID: <20140731172017.GF7842@localhost.localdomain>
References: <cover.1406604806.git.luto@amacapital.net>
 <20140729192056.GA6308@redhat.com>
 <CALCETrX6P7SJQdgc0gTM7FLdwyT_Ld1MWvkLYpTO_2xsvBC9sA@mail.gmail.com>
 <CALCETrXHF5YzPQDvnJs=mFNm2Ff_FekGu_Y8-JyMaWh2hctR7A@mail.gmail.com>
 <20140730165940.GB27954@localhost.localdomain>
 <CALCETrUafpWfnbfZzgu3qSGqyxcG0+6A=A1RE8g++=GrQKD93Q@mail.gmail.com>
 <53DA7550.40905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DA7550.40905@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:56:48AM -0700, H. Peter Anvin wrote:
> On 07/30/2014 10:25 AM, Andy Lutomirski wrote:
> > 
> > And yet x86_64 has this code implemented in assembly even in the
> > slowpath.  Go figure.
> > 
> 
> There is way too much assembly in entry_64.S probably because things
> have been grafted on, ahem, "organically".  It is darn nigh impossible
> to even remotely figure out what goes on in that file.

Always warn your family and give them an estimate return hour before opening that file.
