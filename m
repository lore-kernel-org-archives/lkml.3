Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab3GPTZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:25:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3GPTZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:25:36 -0400
Date: Tue, 16 Jul 2013 12:11:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130716191147.GA1680@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130712005023.GB31005@thunk.org>
 <20130712051451.GC25815@1wt.eu>
 <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
 <s5hwqoqv4oo.wl%tiwai@suse.de>
 <20130716165933.GU22506@sirena.org.uk>
 <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com>
 <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
 <1374000084.6458.36.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374000084.6458.36.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 02:41:24PM -0400, Steven Rostedt wrote:
> On Tue, 2013-07-16 at 11:29 -0700, Linus Torvalds wrote:
> 
> > Anyway, the point I'm making is that Q&A is limited and often even
> > actively misleading ("Hey, I have three tested-by's, so it must be
> > fine"), and we might actually want to have a new class of
> > "non-critical patch that might be worth backporting to stable, but
> > only do so after it's been in a release for some time". Because while
> > it might be an "obvious" fix, maybe it's not critical enough that it
> > needs to be backported _now_ - maybe it could wait a month or two, and
> > get wider testing.
> 
> Should we add another stable tag?
> 
> Have the default Cc: stable have to wait a rc or two in mainline before
> it makes its way to the stable tree. Have a stable-critical for those
> that are bugs that are security fixes than need to be backported ASAP.

People mark stable patches that way already today with a:
	Cc: stable <stable@vger.kernel.org> # delay for 3.12-rc4
or some such wording.  I take those and don't apply them until the noted
release happens, so you can do this if needed.

greg k-h
