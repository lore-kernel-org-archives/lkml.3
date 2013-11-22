Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3KVJ14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:27:56 -0500
Received: from tundra.namei.org ([65.99.196.166]:57914 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab3KVJ1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:27:50 -0500
Date: Fri, 22 Nov 2013 20:36:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [GIT] Security subsystem updates for 3.13
In-Reply-To: <CA+55aFwF8BV+YAD1RzV=yvcN2qVZ5sajBaeR=exqeZL6R-iYqw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1311222034510.22650@tundra.namei.org>
References: <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org> <CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com> <alpine.LRH.2.02.1311191029050.20131@tundra.namei.org> <CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com>
 <alpine.LRH.2.02.1311192319180.27775@tundra.namei.org> <CA+55aFwF8BV+YAD1RzV=yvcN2qVZ5sajBaeR=exqeZL6R-iYqw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Linus Torvalds wrote:

> So for future cases: if there are big independent overhauls of core
> subsystems, I'd really like to see them kept separate, ok?

Yep.

> So guys, make it easier for me to merge these kinds of things, and
> *don't* do what happened this time. Ok? Pretty please?

Ok.


-- 
James Morris
<jmorris@namei.org>
