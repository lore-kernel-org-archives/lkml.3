Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3KMBKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:10:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3KMBJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:09:59 -0500
From: Thomas Renninger <trenn@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/microcode/amd: Tone down printk(), don' t treat a missing firmware file as an error
Date: Wed, 13 Nov 2013 02:09:49 +0100
Message-ID: <3297582.U22CC6mr0K@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.47-2.38-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20131112231008.GC30674@gmail.com>
References: <1384274383-43510-1-git-send-email-trenn@suse.de> <20131112230138.GL12854@pd.tnic> <20131112231008.GC30674@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 13, 2013 12:10:08 AM Ingo Molnar wrote:
> * Borislav Petkov <bp@suse.de> wrote:
...
> > > Shouldn't that be <stable@vger.kernel.org> ?
> > 
> > Yes, it should:
> > 
> > Final-Recipient: rfc822; stable@kernel.org
> > Action: failed
> > Status: 5.0.0
> > Diagnostic-Code: X-Postfix; host mail.kernel.org[198.145.19.201] said: 550
> > 
> >     5.1.1 <stable@kernel.org>: Recipient address rejected: User unknown in
> >     local recipient table (in reply to RCPT TO command)
> 
> Hm, that's really weird, I've been using <stable@kernel.org> for years and
> the commits do get picked up. I also never saw such a mailer failure.
Argh, I used stable@vger.kernel.org for quite some time already.
I copied the wrong one in a rush.
 
> In any case I've changed my pre-cooked alias to <stable@vger.kernel.org>,
> but still I'm wondering why <stable@kernel.org> seems to be working in
> practice - maybe Greg is picking up such commits as well, not via an email
> flow but via scripting?
Do I have to resubmit?

Thanks for picking this one up that quickly,

      Thomas
