Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3KRXX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:23:27 -0500
Received: from tundra.namei.org ([65.99.196.166]:47037 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3KRXXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:23:25 -0500
Date: Tue, 19 Nov 2013 10:30:19 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [GIT] Security subsystem updates for 3.13
In-Reply-To: <CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1311191029050.20131@tundra.namei.org>
References: <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org> <CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Josh Boyer wrote:

> On Wed, Nov 6, 2013 at 7:51 PM, James Morris <jmorris@namei.org> wrote:
> > In this patchset, we finally get an SELinux update, with Paul Moore taking
> > over as maintainer of that code.
> >
> > Also a significant update for the Keys subsystem, as well as maintenance
> > updates to Smack, IMA, TPM, and Apparmor.
> >
> > Please pull.
> >
> > The following changes since commit be408cd3e1fef73e9408b196a79b9934697fe3b1:
> >
> >   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-11-04 06:40:55 -0800)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
> 
> Unless I'm missing something, I don't think this has landed in Linus'
> tree yet.  Linus, did this pull request get NAKed or fall through the
> cracks?

I think Linus is on vacation and merging only sporadically at the moment.



-- 
James Morris
<jmorris@namei.org>
