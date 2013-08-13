Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3HMJhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:37:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57408 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab3HMJhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:37:47 -0400
Date: Tue, 13 Aug 2013 11:37:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shailaja Neelam <neelamshaila@gmail.com>, fweisbec@gmail.com,
        akpm@linux-foundation.org, anish198519851985@gmail.com,
        james.hogan@imgtec.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] fix a Sparse warning in the arch/x86/kernel/irq_work.c
 file
Message-ID: <20130813093745.GA5184@pd.tnic>
References: <CAOUhrBGcH4Oe32cDFs++a1UyKaGNfCm1sCG6UC4an_fO5vDjjQ@mail.gmail.com>
 <20130812202909.373bc152@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130812202909.373bc152@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 08:29:09PM -0400, Steven Rostedt wrote:
> The patch looks good. Let me give you a bit more information and
> background on that function. Just your FYI.

Well, if anything else doesn't pan out, you can always get a job
teaching kernel development! I wish I had JFYIs like that when I started
staring at kernel code.

:-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
