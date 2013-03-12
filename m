Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab3CLT3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:29:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:56996 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab3CLT3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:29:24 -0400
Message-ID: <1363116527.8993.0.camel@pasglop>
Subject: Re: Regression with orderly_poweroff()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>, Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Wed, 13 Mar 2013 06:28:47 +1100
In-Reply-To: <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
References: <1363058712.4534.12.camel@pasglop>
	 <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 07:46 -0700, Linus Torvalds wrote:
> 
> Hmm.. You should really have cc'd the people who acked it and were in
> the sign-off chain too, because all those people are involved with the
> patch as well.

Ah oops, my bad, just used David's original CC list, too much stuff on
my plate before I head out for a big family holiday tomorrow :-)

David, you'll handle it from there ?

Cheers,
Ben.


