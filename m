Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3GPA6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:58:03 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45767 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3GPA6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:58:00 -0400
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is
 on/off
From: Raymond Jennings <shentino@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFzAg-yU4sX2F8NA0+RZT0v_T3vKc_JrPpX9rXE8-Ofd1A@mail.gmail.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
	 <CA+55aFxShsoiTfXUJM2463ZHPNzBsV_VcKBkM4NyGMpk6Cm=iQ@mail.gmail.com>
	 <1373935603.31535.3.camel@warfang>
	 <CA+55aFzAg-yU4sX2F8NA0+RZT0v_T3vKc_JrPpX9rXE8-Ofd1A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Jul 2013 17:57:57 -0700
Message-ID: <1373936277.31535.6.camel@warfang>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 17:53 -0700, Linus Torvalds wrote:
> On Mon, Jul 15, 2013 at 5:46 PM, Raymond Jennings <shentino@gmail.com> wrote:
> >
> > I'd like to point out that Google Chrome also makes use of CONFIG_ tests
> > to detect support for namespaces and pid containers and stuff.
> 
> Hmm. It must work fine despite that. Because I run self-compiled
> kernels and there are no config files to be found by user apps.
> Neither in /proc nor in /boot. And I'm using chrome to write this.
> 
>               Linus

It could be the quirks of my package manager though.

I run Gentoo, so it's entirely possible that the ebuild is doing all the
bitching, but chrome itself just fails gracefully and falls back to not
using those features if it can't find them.

I imagine though that the same stuff applying to applications in general
should also apply to installers.

Anyway I just wanted to highlight that it's not just the xen stuff
that's peeking at kernel config.

