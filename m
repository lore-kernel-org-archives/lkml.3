Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaIWF7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:59:18 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54307 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaIWF7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:59:16 -0400
MIME-Version: 1.0
In-Reply-To: <32c24277-c815-4ca6-98c5-77bf040c1384@email.android.com>
References: <20140919104021.GA11552@gmail.com>
	<CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
	<20140923053510.GB27825@gmail.com>
	<20140923053711.GA28704@gmail.com>
	<32c24277-c815-4ca6-98c5-77bf040c1384@email.android.com>
Date: Mon, 22 Sep 2014 22:59:15 -0700
X-Google-Sender-Auth: PSJUhc_wYonjOwxFJbxOKf5ftF4
Message-ID: <CA+55aFyfhMA58ko_rMMbHYuprif+HGbMfwJ-2L1wxAE6-7cAog@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yup. It's 9cb0e394234d ("x86/efi: Fixup GOT in all boot code paths")
according to bisect.

Now building current git with that reverted, just to double-check,
before pushing the revert out.

           Linus

On Mon, Sep 22, 2014 at 10:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> That would be my guess, too.
>
> On September 22, 2014 10:37:11 PM PDT, Ingo Molnar <mingo@kernel.org> wrote:
>>
>>Wrong sha1: my guess is on 9cb0e394234d, the GOT fixup.
