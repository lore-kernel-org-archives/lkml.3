Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JVIX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:23:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58329 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab3JVIXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:23:55 -0400
Date: Tue, 22 Oct 2013 10:23:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Linux Torvalds <torvalds@osdl.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2] x86: add kconfig options for newer 64-bit processors
Message-ID: <20131022082355.GA10268@nazgul.tnic>
References: <526325C9.7030705@gmail.com>
 <20131020091813.GA4972@pd.tnic>
 <52646E0E.6040204@gmail.com>
 <20131021105401.GA5019@nazgul.tnic>
 <526513B5.5050203@gmail.com>
 <20131021135917.GA6117@nazgul.tnic>
 <52653847.1050606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52653847.1050606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 10:20:55AM -0400, Austin S Hemmelgarn wrote:
> By this same logic though, none of the x86 processor tuning options
> currently in the kernel should have been put in in the first place
> (and, taking it to an extreme, should in fact be removed).

Some of them make sense like MATOM as Atom supports a different subset
of x86 insns, MOVBE being one example. And there's no need to touch them
as unnecessary code churn is something we don't do.
