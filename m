Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3KTAOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:14:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38903 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751421Ab3KTAOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:14:38 -0500
Date: Tue, 19 Nov 2013 19:14:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
Message-ID: <20131119191435.4dce1499@gandalf.local.home>
In-Reply-To: <20131119160855.2527630f87d060801d9ee3bb@linux-foundation.org>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
	<20131119155907.11fbdecea0aa40764a3d927a@linux-foundation.org>
	<20131119190426.27b010e4@gandalf.local.home>
	<20131119160855.2527630f87d060801d9ee3bb@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 16:08:55 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:


> > Do I hear any complaints about removing it just
> > for emacs users?
> 
> Probably not, as only 0.0001% of them are reading this thread :(

Then I'm guessing that the answer is to just do it for emacs users.
That way, if anyone uses this feature, they will complain then :-)

The worse we can do is to just revert it, as this isn't something like
a user ABI or anything.

-- Steve

