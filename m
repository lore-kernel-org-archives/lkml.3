Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3KSFbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:31:06 -0500
Received: from tundra.namei.org ([65.99.196.166]:35370 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3KSFbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:31:04 -0500
Date: Tue, 19 Nov 2013 16:38:02 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [GIT] Security subsystem updates for 3.13
In-Reply-To: <CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1311191637280.20384@tundra.namei.org>
References: <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org> <CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com> <alpine.LRH.2.02.1311191029050.20131@tundra.namei.org>
 <CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Linus Torvalds wrote:

> On Mon, Nov 18, 2013 at 3:30 PM, James Morris <jmorris@namei.org> wrote:
> > On Mon, 18 Nov 2013, Josh Boyer wrote:
> >>
> >> Unless I'm missing something, I don't think this has landed in Linus'
> >> tree yet.  Linus, did this pull request get NAKed or fall through the
> >> cracks?
> >
> > I think Linus is on vacation and merging only sporadically at the moment.
> 
> No,while it is true that I've been traveling, I've also been actively
> merging, and no, that pull request isn't lost.
> 
> I don't really like the look of it though (particularly all the magic
> new keys changes), so I've been delaying it and merging other regular
> stuff that I don't have any issues with. I'm leaving that pull for
> later in order to go over it more carefully when I'm not doing fifteen
> other pulls the same day..
> 
> If somebody wants to explain about the rationale new keys code, that might help.

Thanks -- I've cc'd David for comment.


-- 
James Morris
<jmorris@namei.org>
