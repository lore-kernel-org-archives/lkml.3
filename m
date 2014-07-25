Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbaGYNWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:22:30 -0400
Received: from imap.thunk.org ([74.207.234.97]:56408 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbaGYNW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:22:28 -0400
Date: Fri, 25 Jul 2014 09:22:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Message-ID: <20140725132225.GQ1865@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
 <20140724151814.GE32421@khazad-dum.debian.net>
 <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
 <20140724190206.GL6673@thunk.org>
 <20140724203019.GA20737@khazad-dum.debian.net>
 <20140724232434.GN6673@thunk.org>
 <CALCETrVgKMVnBuzE+bCXaUPRrqhVxwv4AXmJrUJSYws5rZxhJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVgKMVnBuzE+bCXaUPRrqhVxwv4AXmJrUJSYws5rZxhJw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:27:36PM -0700, Andy Lutomirski wrote:
> 
> I think that people might do:
> 
> try getrandom(GRND_RANDOM)
> fall back to /dev/random
> fall back to something intensely stupid
> 
> We want them to at least attempt the fallback from GRND_RANDOM to !GRND_RANDOM.

We can't legislate against stupidity.  Seriously, the best way to do
this is to write a good userspace library and encourage application
writers to use it.

Regards,

						- Ted
