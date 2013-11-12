Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3KLXKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:10:18 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:41793 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3KLXKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:10:11 -0500
Date: Wed, 13 Nov 2013 00:10:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, trenn@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/microcode/amd: Tone down printk(), don' t
 treat a missing firmware file as an error
Message-ID: <20131112231008.GC30674@gmail.com>
References: <1384274383-43510-1-git-send-email-trenn@suse.de>
 <tip-11f918d3e2d3861b6931e97b3aa778e4984935aa@git.kernel.org>
 <20131112224511.GJ12854@pd.tnic>
 <20131112230138.GL12854@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112230138.GL12854@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@suse.de> wrote:

> (fixed stable@vger).
> 
> On Tue, Nov 12, 2013 at 11:45:11PM +0100, Borislav Petkov wrote:
> > On Tue, Nov 12, 2013 at 01:58:00PM -0800, tip-bot for Thomas Renninger wrote:
> > > Commit-ID:  11f918d3e2d3861b6931e97b3aa778e4984935aa
> > > Gitweb:     http://git.kernel.org/tip/11f918d3e2d3861b6931e97b3aa778e4984935aa
> > > Author:     Thomas Renninger <trenn@suse.de>
> > > AuthorDate: Tue, 12 Nov 2013 17:39:43 +0100
> > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > CommitDate: Tue, 12 Nov 2013 22:03:49 +0100
> > > 
> > > x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error
> > > 
> > > Do it the same way as done in microcode_intel.c: use pr_debug()
> > > for missing firmware files.
> > > 
> > > There seem to be CPUs out there for which no microcode update
> > > has been submitted to kernel-firmware repo yet resulting in
> > > scary sounding error messages in dmesg:
> > > 
> > >   microcode: failed to load file amd-ucode/microcode_amd_fam16h.bin
> > > 
> > > Signed-off-by: Thomas Renninger <trenn@suse.de>
> > > Acked-by: Borislav Petkov <bp@suse.de>
> > > Cc: <stable@kernel.org>
> > 
> > Shouldn't that be <stable@vger.kernel.org> ?
> 
> Yes, it should:
> 
> Final-Recipient: rfc822; stable@kernel.org
> Action: failed
> Status: 5.0.0
> Diagnostic-Code: X-Postfix; host mail.kernel.org[198.145.19.201] said: 550
>     5.1.1 <stable@kernel.org>: Recipient address rejected: User unknown in
>     local recipient table (in reply to RCPT TO command)

Hm, that's really weird, I've been using <stable@kernel.org> for years and 
the commits do get picked up. I also never saw such a mailer failure.

In any case I've changed my pre-cooked alias to <stable@vger.kernel.org>, 
but still I'm wondering why <stable@kernel.org> seems to be working in 
practice - maybe Greg is picking up such commits as well, not via an email 
flow but via scripting?

Thanks,

	Ingo
