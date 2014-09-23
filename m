Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaIWMSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbaIWMSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:18:52 -0400
Date: Tue, 23 Sep 2014 08:18:37 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140923121837.GA7858@hansolo.jdub.homelinux.org>
References: <20140919104021.GA11552@gmail.com>
 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
 <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <32c24277-c815-4ca6-98c5-77bf040c1384@email.android.com>
 <CA+55aFyfhMA58ko_rMMbHYuprif+HGbMfwJ-2L1wxAE6-7cAog@mail.gmail.com>
 <1411455419.21380.345.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411455419.21380.345.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:56:59AM +0100, Matt Fleming wrote:
> On Mon, 2014-09-22 at 22:59 -0700, Linus Torvalds wrote:
> > Yup. It's 9cb0e394234d ("x86/efi: Fixup GOT in all boot code paths")
> > according to bisect.
> > 
> > Now building current git with that reverted, just to double-check,
> > before pushing the revert out.
> 
> Crap. Sorry about that. I did get a report last night from Josh (Cc'd)
> that the above commit caused hangs during boot on a bunch of his
> machines. All grub2 and all secure boot enabled, I think.

All shim/grub2, but only one machine has SB enabled.  All of the kernels are
signed still.

josh
