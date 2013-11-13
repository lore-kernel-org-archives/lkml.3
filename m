Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3KMBkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:40:05 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52786 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab3KMBj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:39:56 -0500
Date: Wed, 13 Nov 2013 02:39:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/microcode/amd: Tone down printk(), don' t
 treat a missing firmware file as an error
Message-ID: <20131113013951.GB3300@gmail.com>
References: <1384274383-43510-1-git-send-email-trenn@suse.de>
 <20131112230138.GL12854@pd.tnic>
 <20131112231008.GC30674@gmail.com>
 <3297582.U22CC6mr0K@hammer82.arch.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3297582.U22CC6mr0K@hammer82.arch.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Renninger <trenn@suse.de> wrote:

> On Wednesday, November 13, 2013 12:10:08 AM Ingo Molnar wrote:
> > * Borislav Petkov <bp@suse.de> wrote:
> ...
> > > > Shouldn't that be <stable@vger.kernel.org> ?
> > > 
> > > Yes, it should:
> > > 
> > > Final-Recipient: rfc822; stable@kernel.org
> > > Action: failed
> > > Status: 5.0.0
> > > Diagnostic-Code: X-Postfix; host mail.kernel.org[198.145.19.201] said: 550
> > > 
> > >     5.1.1 <stable@kernel.org>: Recipient address rejected: User unknown in
> > >     local recipient table (in reply to RCPT TO command)
> > 
> > Hm, that's really weird, I've been using <stable@kernel.org> for years and
> > the commits do get picked up. I also never saw such a mailer failure.
> Argh, I used stable@vger.kernel.org for quite some time already.
> I copied the wrong one in a rush.
>  
> > In any case I've changed my pre-cooked alias to <stable@vger.kernel.org>,
> > but still I'm wondering why <stable@kernel.org> seems to be working in
> > practice - maybe Greg is picking up such commits as well, not via an email
> > flow but via scripting?
> Do I have to resubmit?

No need, it's fine.

Thanks,

	Ingo
