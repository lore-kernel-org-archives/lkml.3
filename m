Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161467Ab3FUHgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:36:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161296Ab3FUHgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:36:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mailbox tree
Date: Fri, 21 Jun 2013 09:36:09 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>
References: <20130621162656.bb94e0fa8b6813781b804a73@canb.auug.org.au> <CAOesGMjszju75jo6Ej6C=0-rfdPLuEj0mwmU1zYvFvYw1dyQCA@mail.gmail.com> <20130621071239.GM5523@atomide.com>
In-Reply-To: <20130621071239.GM5523@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306210936.09593.arnd@arndb.de>
X-Provags-ID: V02:K0:QQwJPoURxJdvFoteS0gWADSc3u9NOItmUw/M2wcnqrh
 kK9OkuENtlW4sGc0kl2OSLwItv698HrwVDDgBgsJARniLvw1Mm
 +Hj3Dm2o7RsqQhz/MlMAZE72jcZvq0NTNWztgot2mTExwy2MKQ
 vpl5q3AqDpiTg8g2FTLaS2+1bNxRkgM8hlYxsitXf2P9/QHASc
 pHS5Y19h2Mp7CUm3cmlda3R50+MfHKBBsbvlylHzZy9KIWmUEm
 qidIdYHVPjFOqQE05aYra1o4eDKTWK51tB8XbReW8NCqGdKYnI
 km8eoXlHg2RP4K/SMUKs3NFY7epZ25F+lySNRsytSX8CO603cP
 rEG5D6TzYE4R+TrK9U44=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013, Tony Lindgren wrote:
> > I wonder if this mess is caused by the fact that I did the revert
> > instead of rebuilding our for-next and dropping the merge in the first
> > place.
> > 
> > I'll rebuild our for-next (or maybe Arnd will beat me to it) before
> > next linux-next build, i.e. Sunday night my time.
> 
> Could be, especially if some of the commits are the same in the reverted
> branch and newly merged branch as git might think that some merges have
> been already resolved the right way earlier.

I already rebuilt the arm-soc tree before Stephen started with today's
linux-next, so I think the conflict is elsewhere.

It's probably best if Suman Anna rebases the mailbox tree on top of
the omap mailbox branch that I took.

	Arnd
