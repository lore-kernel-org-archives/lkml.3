Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbaKUOwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:52:15 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:63379 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaKUOwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:52:13 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
Date: Fri, 21 Nov 2014 15:51:59 +0100
Message-ID: <1775324.vr1BUO4kWb@xrated>
User-Agent: KMail/4.14.3 (Linux/3.11.10-21-desktop; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CAJfpegtRktN8BdOogCMW++Gar02j06K=9OYOyDMBbwBZq6_=Hg@mail.gmail.com>
References: <20141120164531.GB3596@tucsk> <1962959.JkOx4gJGaG@xrated> <CAJfpegtRktN8BdOogCMW++Gar02j06K=9OYOyDMBbwBZq6_=Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DxeCUYgERVXD4e9SGzN8ZmzfuV6VlPfLcHkpR9TTdiy
 MF3cHD4pt9AOdvRppjXk+ZErbihZOe7i06maq62yGUnst4SfOk
 hmmYFg1DMsiKB+SFEfle0P+/vHNW1nH8pcnMRlp7oGO8qh+lI5
 zBP9eP2TVH+P56aT6dnieiCg9qJu5wUzcGspKCFPxmHLPukPKg
 8zgfXFriSO6ydFOgReCLiGYcfElXNISSewAHJmBGjh2ViItbKF
 4I5JBeFnxHfBt3ibsrpw9qtSLMjUM2u2a2AVSDFS4mlrRs3GL5
 jxL5DQmdjf6PFt+hjQeXqrPpYDD2ERhw2dS62Pzrb9464HR3g=
 =
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag, 21. November 2014 13:41:57 Miklos Szeredi wrote:
> On Fri, Nov 21, 2014 at 12:32 PM, Hans-Peter Jansen <hpj@urpla.net> wrote:
> > Dear Miklos,
> > 
> > On Donnerstag, 20. November 2014 17:45:31 Miklos Szeredi wrote:
> >> The biggest change is to rename the filesystem from "overlayfs" to
> >> "overlay". This will allow legacy overlayfs to be easily carried by
> >> distros
> >> alongside the new mainline one.
> > 
> > Would you kindly give a firm elaboration of this rename?
> > 
> 
> See this thread:
> 
> https://lkml.org/lkml/2014/11/18/433

Okay, thanks. I  must have missed this one. "overlay" is as good as a name can 
be, IMHO.

Cheers,
Pete
