Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab3CLWdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397Ab3CLWdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:51 -0400
Date: Tue, 12 Mar 2013 18:33:45 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: ipc/testmsg GPF.
Message-ID: <20130312223345.GA22747@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Hurley <peter@hurleysoftware.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130307213819.GB19543@redhat.com>
 <1362788821.7755.12.camel@thor.lan>
 <20130311182621.GA24965@redhat.com>
 <1363028602.3234.38.camel@thor.lan>
 <20130312150236.27ba998a00d31470a2d8aca0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312150236.27ba998a00d31470a2d8aca0@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 03:02:36PM -0700, Andrew Morton wrote:
 > On Mon, 11 Mar 2013 15:03:22 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:
 > 
 > > On Mon, 2013-03-11 at 14:26 -0400, Dave Jones wrote:
 > > >  > >         {
 > > > 
 > > > I just hit this again on rc2 which looks like it has the fixes that
 > > > Peter mentions above.  This time rdi was 6b6b6b6b6b6b6b7b
 > > > 
 > > > 	Dave
 > > 
 > > Sorry, Dave. The fix must be in the other 8 patches that Andrew didn't
 > > want to apply. I run trinity 10 or more times a day and can't get this
 > > to trigger with the whole series.
 > 
 > Are you able to reproduce the bug with current mainline?

Yep.
I'll give this patchset a try tomorrow.

	Dave

