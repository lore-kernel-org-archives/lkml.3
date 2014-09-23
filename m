Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaIWG5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:57:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:46066 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaIWG5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,578,1406617200"; 
   d="scan'208";a="577367900"
Message-ID: <1411455419.21380.345.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] x86 fixes
From: Matt Fleming <matt.fleming@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>
Date: Tue, 23 Sep 2014 07:56:59 +0100
In-Reply-To: <CA+55aFyfhMA58ko_rMMbHYuprif+HGbMfwJ-2L1wxAE6-7cAog@mail.gmail.com>
References: <20140919104021.GA11552@gmail.com>
	 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
	 <20140923053510.GB27825@gmail.com> <20140923053711.GA28704@gmail.com>
	 <32c24277-c815-4ca6-98c5-77bf040c1384@email.android.com>
	 <CA+55aFyfhMA58ko_rMMbHYuprif+HGbMfwJ-2L1wxAE6-7cAog@mail.gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.182]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 22:59 -0700, Linus Torvalds wrote:
> Yup. It's 9cb0e394234d ("x86/efi: Fixup GOT in all boot code paths")
> according to bisect.
> 
> Now building current git with that reverted, just to double-check,
> before pushing the revert out.

Crap. Sorry about that. I did get a report last night from Josh (Cc'd)
that the above commit caused hangs during boot on a bunch of his
machines. All grub2 and all secure boot enabled, I think.

Linus, what are the particulars of your Sony machine? Are you running
with secure boot on? Is is a regular grub2/Fedora machine?

Reverting this is obviously the way to go, but it would be useful to
diagnose this failure some more - there's clearly a gap in my testing.

