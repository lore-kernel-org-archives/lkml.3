Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3J2Vam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:30:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab3J2Val (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:30:41 -0400
Date: Tue, 29 Oct 2013 22:30:37 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Karl Kiniger <karl.kiniger@med.ge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131029213037.GB12814@quack.suse.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
 <20131025091555.GA30895@kipc2.localdomain>
 <20131029203050.GE9568@quack.suse.cz>
 <20131029134346.9e5873bae3630e9a69891773@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029134346.9e5873bae3630e9a69891773@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-10-13 13:43:46, Andrew Morton wrote:
> On Tue, 29 Oct 2013 21:30:50 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > Andrew has queued up a patch series from Maxim Patlasov which removes this
> > caveat but currently we don't have a way admin can switch that from
> > userspace. But I'd like to have that tunable from userspace exactly for the
> > cases as you describe below.
> 
> This?
> 
> commit 5a53748568f79641eaf40e41081a2f4987f005c2
> Author:     Maxim Patlasov <mpatlasov@parallels.com>
> AuthorDate: Wed Sep 11 14:22:46 2013 -0700
> Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Wed Sep 11 15:58:04 2013 -0700
> 
>     mm/page-writeback.c: add strictlimit feature
> 
> That's already in mainline, for 3.12.
  Yes, I should have checked the code...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
