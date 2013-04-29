Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab3D2XX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:23:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3570 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab3D2XX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:23:56 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=KBd73aRfIukA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bsvyib-zOJsA:10 a=VwQbUJbxAAAA:8 a=Aeb1Wc_000gx1NaVisMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367277834.30667.27.camel@gandalf.local.home>
Subject: Re: [PATCH 0/2] [GIT PULL] localmodconfig: Fix missing depends of
 config files included in if statements
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Date: Mon, 29 Apr 2013 19:23:54 -0400
In-Reply-To: <CA+55aFzEwRUWVQ8x1+f=6R_9+JO_Rmg=u2E1k_6jLuQEAorgtQ@mail.gmail.com>
References: <20130429195100.202681236@goodmis.org>
	 <CA+55aFzEwRUWVQ8x1+f=6R_9+JO_Rmg=u2E1k_6jLuQEAorgtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 14:01 -0700, Linus Torvalds wrote:
> On Mon, Apr 29, 2013 at 12:51 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >
> > Please pull the latest ktest-v3.10 tree, which can be found at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
> > ktest-v3.10
> 
> Hmm. This is your ktest tree (which I already pulled the ktest changes
> from), not your localmodconfig tree. But then all the explanations are
> about your localmodconfig changes.
> 
> I assume you *meant* to ask me to pull your linux-kconfig.git tree?

Face palm!

> That has a "ktest-v3.10" tag too, but I think that's a mistake too,
> and you *meant* to make a tag called "localconfig" like you have done
> in the past.
> 
> There's just too much confusion here for me to touch anything at all,
> so please fix things up.

Yeah, sorry. I have no idea what I was thinking. I was doing my double
check of ktest changes and must have still had that on my mind when I
switched over to the localmodconfig stuff.

I'll clean it up.

-- Steve


