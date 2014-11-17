Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaKQVVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:21:14 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:46720 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaKQVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:21:13 -0500
Date: Mon, 17 Nov 2014 22:21:10 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Junjie Mao <eternal.n08@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20141117212110.GF344@x4>
References: <20141116090743.GA19172@gmail.com>
 <20141117074247.GB340@x4>
 <20141117082724.GA344@x4>
 <20141117135854.GA15076@gmail.com>
 <CAGXu5j+mHoKpb2aNyxZWEWCOLRS=QeJXZxjU7YHDVcM3uuXZUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+mHoKpb2aNyxZWEWCOLRS=QeJXZxjU7YHDVcM3uuXZUQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.11.17 at 13:02 -0800, Kees Cook wrote:
> 
> Eek, well, the warning worked, at least (".bss and .brk lack common
> file offset") since that was kind of an assumption in the script I
> wanted to make sure we'd catch if it wasn't true.

It depends on the linker being used. gold (my default) triggers the issue,
ld.bfd is fine.

-- 
Markus
