Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3LCUx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:53:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab3LCUx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:53:57 -0500
Date: Tue, 3 Dec 2013 21:54:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
	page directly
Message-ID: <20131203205400.GA25735@redhat.com>
References: <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz> <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com> <20131203184909.GA17571@redhat.com> <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com> <529E2F0C.8070405@zytor.com> <20131203200147.GB19083@redhat.com> <529E3D4C.9070403@zytor.com> <20131203203826.GA24812@redhat.com> <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, H. Peter Anvin wrote:
>
> There is no architecture-independent way to make code globally visible.

Then I probably misunderstood "globally". Or something else.

So do you think the patch I sent is wrong? Why?

I am totally confused.

Oleg.

