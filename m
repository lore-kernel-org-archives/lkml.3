Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3G2NA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:00:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45975 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3G2NAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:00:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>, Samuel Ortiz <sameo@linux.intel.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development process
Date: Mon, 29 Jul 2013 15:10:33 +0200
Message-ID: <7008541.g5m1pJPVp1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1307291230270.18809@pobox.suse.cz>
References: <20130729102452.GA2682@zurbaran> <alpine.LNX.2.00.1307291230270.18809@pobox.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 12:31:37 PM Jiri Kosina wrote:
> On Mon, 29 Jul 2013, Samuel Ortiz wrote:
> 
> > - Developement process: Jon Corbet's article about our changelog raised
> >   one interesting question: How can we better track how single SOB
> >   patches are getting merged ?

That actually is simple enough.

Check out the Linus' master branch and do

$ git log --ancestry-path --merges <commit>..

and read the log from the bottom to the top.

> >   Should maintainers add their SOB when
> >   they pull from subsystems maintainers (If they can) ? This is
> >   something I care about from both my MFD and NFC maintainer
> >   perspectives as I both pull from MFD sub maintainers and am John
> >   Linville's NFC sub maintainer.
> 
> This is difficult ... I think that in some sense merging from subsystem 
> maintainer tree can be viewed as an "implicit" Signoff, although this 
> hasn't been formalized anywhere.
> 
> I am afraid there is no way git could handle this easily without rebasing.

No, there's none, as you'll always change the commit hash by adding tags to it.

Thanks,
Rafael

