Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3HUPop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab3HUPoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:44:44 -0400
Date: Wed, 21 Aug 2013 11:43:55 -0400
From: Dave Jones <davej@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
Message-ID: <20130821154355.GA20784@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	Kees Cook <keescook@chromium.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
 <20130730221435.GA22240@redhat.com>
 <20130730231120.GC30725@blackmetal.musicnaut.iki.fi>
 <20130730231533.GA26824@redhat.com>
 <20130730235834.GD30725@blackmetal.musicnaut.iki.fi>
 <20130731000444.GC1281@redhat.com>
 <20130731094012.GU24642@n2100.arm.linux.org.uk>
 <20130731142430.GA4545@redhat.com>
 <20130821152614.GN17845@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821152614.GN17845@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 04:26:14PM +0100, Russell King - ARM Linux wrote:
 > On Wed, Jul 31, 2013 at 10:24:30AM -0400, Dave Jones wrote:
 > > On Wed, Jul 31, 2013 at 10:40:12AM +0100, Russell King - ARM Linux wrote:
 > >  > On Tue, Jul 30, 2013 at 08:04:44PM -0400, Dave Jones wrote:
 > >  > > To use ARM as an example, the bugs I've seen have mostly been in arch specific
 > >  > > code that does things like page-table manipulation.  The chromebook bugs I
 > >  > > was hitting for eg were various kinds of PTE corruption warnings. 
 > >  > 
 > >  > Hmm, really?  Did you reported these bugs?  I'm not aware of mainline
 > >  > having any changes related to bug reports on PTEs on ARM.
 > > 
 > > I wasn't sure if it was a googleism, or happens on mainline, so no.
 > 
 > I've been running several iterations of it for a while (== up to 10 minutes
 > run time - which is normally about how long it takes to find the rather-too-
 > exposed kmalloc in sys_oabi_epoll_wait) and so far have seen no sign of any
 > page table corruption.

awesome. Guess it was a google specific issue then.
(Or something that got fixed post 3.4)

 > Maybe you can give some ideas as to how you were running it?  Was it
 > running as root or as a normal user? 

yeah, unpriv'd user. 

 > Were there any nonstandard platform
 > specific devices in /dev which that user could access - such as graphics
 > or video decoder devices which could be exposing big holes?

I'm not sure what google patched into that kernel altogether, so who knows..

	Dave

