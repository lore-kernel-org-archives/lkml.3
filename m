Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaIWHhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:37:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:32767 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbaIWHhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:37:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,578,1406617200"; 
   d="scan'208";a="577386199"
Message-ID: <1411457738.21380.360.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] x86 fixes
From: Matt Fleming <matt.fleming@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Josh Boyer <jwboyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@kernel.org>
Date: Tue, 23 Sep 2014 08:35:38 +0100
In-Reply-To: <CA+55aFz+2tf7zEGjVmkVuncZssiDdVRKJ=OUfgnDFf2TYN-KvA@mail.gmail.com>
References: <20140919104021.GA11552@gmail.com>
	 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
	 <20140923053510.GB27825@gmail.com> <20140923053711.GA28704@gmail.com>
	 <32c24277-c815-4ca6-98c5-77bf040c1384@email.android.com>
	 <CA+55aFyfhMA58ko_rMMbHYuprif+HGbMfwJ-2L1wxAE6-7cAog@mail.gmail.com>
	 <1411455419.21380.345.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CA+55aFz+2tf7zEGjVmkVuncZssiDdVRKJ=OUfgnDFf2TYN-KvA@mail.gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 00:07 -0700, Linus Torvalds wrote:
> 
> On Sep 22, 2014 11:57 PM, "Matt Fleming" <matt.fleming@intel.com>
> wrote:
> >
> > Linus, what are the particulars of your Sony machine? Are you
> running
> > with secure boot on? Is is a regular grub2/Fedora machine?
> 
> It's a regular fedora 20 install with grub2, yes, and set for EFI boot
> rather than legacy bios. But I don't play around with signing stuff,
> so it ends up saying "booting in insecure mode" at startup (our
> something like that, I'm not at the machine right now).

OK that's good at least. There seems to be a pattern here, booting with
Fedora's grub2.

> > Reverting this is obviously the way to go, but it would be useful to
> > diagnose this failure some more - there's clearly a gap in my
> testing.
> 
> It literally just reboots after loading the kernel, so not a lot to go
> on. I can try things out if you want to, though. 

Thanks! I'll let you know. I'm gonna try and recreate the problem here
first since this early boot debugging is a massive PITA.

