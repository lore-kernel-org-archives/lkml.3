Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3B1Esy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:48:54 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:50929 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B1Esw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:48:52 -0500
Date: Wed, 27 Feb 2013 22:48:47 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/3] build linux-next without perl
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Dave Jones <davej@redhat.com>, David Howells <dhowell@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, Michal Marek <mmarek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, x86@kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1361944667.957820@landley.net>
	<20130227135155.c04453db.akpm@linux-foundation.org>
In-Reply-To: <20130227135155.c04453db.akpm@linux-foundation.org> (from
	akpm@linux-foundation.org on Wed Feb 27 15:51:55 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362026927.15531.2@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 03:51:55 PM, Andrew Morton wrote:
> On Tue, 26 Feb 2013 21:57:52 -0800 (PST)
> Rob Landley <rob@landley.net> wrote:
> 
> > Before 2.6.25 building Linux never required perl. This patch series  
> removes
> > the requirement from basic kernel builds (tested on i686, x86_64,  
> arm, mips,
> > powerpc, sparc, sh4, and m68k). Now updated to 3.8-rc1.
> >
> > Note, this removes perl from the _build_ environment, not from the  
> _development_
> > environment. This is approximately the same logic behind "make  
> menuconfig"
> > requiring curses but "make oldconfig" not requiring curses.  
> Including
> > zconf.lex.c_shipped in kconfig and then requiring perl makes no  
> sense.
> >
> > ...
> >
> > Mostly people just copy the patches into their local projects (ala
> > https://github.com/rofl0r/sabotage/tree/master/KEEP ) but I'm  
> reposting
> > them to linux-kernel after Gentoo considered using these patches,  
> but didn't
> > because they weren't upstream:
> >   https://bugs.gentoo.org/show_bug.cgi?id=421483
> 
> Sitting here scratching head wondering why you-need-perl is a problem
> for anyone.
> 
> That gentoo bug report provides some explanation: "perl was removed
> from @system".  But I expect other people have different reasons.
> 
> IOW, please better describe the motivation for this patchset.

P.S. A much shorter reply than mine, from David Anders:

https://plus.google.com/101339419642360856354/posts/AyRnz2REq8C

Rob