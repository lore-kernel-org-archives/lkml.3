Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3GPCcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:32:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3GPCcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:32:15 -0400
Date: Mon, 15 Jul 2013 19:32:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH-v3 00/17] staging/lustre: fix various build issues
Message-Id: <20130715193224.dbbbfb02.akpm@linux-foundation.org>
In-Reply-To: <CA+a=Yy6cC9rYcmAka2652UhJFse9eVfOtfg96SiObBiwsw+zQQ@mail.gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
	<1373908589.2062.18.camel@joe-AO722>
	<20130715184030.GA17220@kroah.com>
	<20130715121357.42ef2826750909c1fc57788a@linux-foundation.org>
	<20130716000755.GC26261@kroah.com>
	<CA+a=Yy6cC9rYcmAka2652UhJFse9eVfOtfg96SiObBiwsw+zQQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 10:21:23 +0800 Peng Tao <bergwolf@gmail.com> wrote:

> >> See the five patches I sent you on July 8 ;)
> >>
> >> I'll resend.
> >
> > I got them, I couldn't apply them until after -rc1 is out, so I'll queue
> > them up later this week.
> >
> Hi Greg and Andrew,
> 
> One issue with the five patches is that the shrinker API change is not
> in Linus' tree. So if Greg merges them in staging tree, Lustre cannot
> build there. Is it OK to break in staging tree and just to make sure
> -next can build?

erk, I forgot about that.

Please send Greg a full patchset against current Linus mainline.  Then,
ideally, send me the patches which adapt that patchset to the new
shrinker API.

Or don't worry about the second part and I'll fix things up at my end.
