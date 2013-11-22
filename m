Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3KVOBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:01:12 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53150 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab3KVOBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:01:08 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwF8BV+YAD1RzV=yvcN2qVZ5sajBaeR=exqeZL6R-iYqw@mail.gmail.com>
References: <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org>
	<CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com>
	<alpine.LRH.2.02.1311191029050.20131@tundra.namei.org>
	<CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com>
	<alpine.LRH.2.02.1311192319180.27775@tundra.namei.org>
	<CA+55aFwF8BV+YAD1RzV=yvcN2qVZ5sajBaeR=exqeZL6R-iYqw@mail.gmail.com>
Date: Fri, 22 Nov 2013 09:01:05 -0500
X-Google-Sender-Auth: 86rTH1eC2AEr2tdVPvNYU5_jLVY
Message-ID: <CA+5PVA7QKW2PvbQT1R5idaUEttbcskNA0jgtp8=yayCptjKL5w@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.13
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> In short: this is exactly the kind of thing I *don't* enjoy merging,
> because the code that needed review was
>
>  - mixed up with other changes that had nothing to do with it
>  - had no pointers to help me review it
>  - had zero information about others who had possibly reviewed it before
>
> and quite frankly, without the extended explanation of what the
> changes were for (which I also didn't get initially), I'd probably
> have decided half-way that it's not worth the headache.
>
> In the end, the code didn't look bad, and I didn't find any obvious
> problems, but there's very much a reason why I merged this over two
> weeks after the first pull request was originally sent to me.
>
> So guys, make it easier for me to merge these kinds of things, and
> *don't* do what happened this time. Ok? Pretty please?

If it makes you feel any more confident, we've been carrying the keys
code during the development of Fedora 20 (and rawhide) as patches.
They were needed to solve some issues some of the userspace people
were seeing that David mentioned in his explanation.  The issues that
have cropped up were all fixed in the various follow up commits
included in the pull and we haven't hit any others that I'm aware of.

josh
