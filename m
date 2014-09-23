Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaIWGHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:07:06 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:35378 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIWGHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyfhMA58ko_rMMbHYuprif+HGbMfwJ-2L1wxAE6-7cAog@mail.gmail.com>
References: <20140919104021.GA11552@gmail.com>
	<CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
	<20140923053510.GB27825@gmail.com>
	<20140923053711.GA28704@gmail.com>
	<32c24277-c815-4ca6-98c5-77bf040c1384@email.android.com>
	<CA+55aFyfhMA58ko_rMMbHYuprif+HGbMfwJ-2L1wxAE6-7cAog@mail.gmail.com>
Date: Mon, 22 Sep 2014 23:07:02 -0700
X-Google-Sender-Auth: _KBCdBLmLc3dsemksjXhSpzV7Go
Message-ID: <CA+55aFzjvfdsV39dojvFzb3LYr7wSMmPG80v9xwQcux603VeTQ@mail.gmail.com>
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

On Mon, Sep 22, 2014 at 10:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Now building current git with that reverted, just to double-check,
> before pushing the revert out.

Double-checked and verified. Revert pushed out,

           Linus
