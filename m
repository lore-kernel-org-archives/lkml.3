Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3ITE46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 00:56:58 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44637 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3ITE44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 00:56:56 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130920144612.5741656ad6ffa8e6739d391c@canb.auug.org.au>
References: <20130920144612.5741656ad6ffa8e6739d391c@canb.auug.org.au>
Date: Thu, 19 Sep 2013 21:56:55 -0700
Message-ID: <CAOesGMjO0JQ8Whm_MEXrOnFFPAG8MXBiQpddV6e8jRR6rcCkTQ@mail.gmail.com>
Subject: Re: linux-next: taking a break
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 9:46 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> I will be having a 3 week break leading up to the kernel
> summit.  This means that next-20130927 (next Friday) will be the last
> linux-next release until next-20131028 (or maybe 29 depending on
> jetlag).  I presume that Linus will be up to v3.12-rc7 by then and -rc7
> is often the last before a release ... Please plan accordingly.

This brings up a subject that could be good to discuss at KS: Do you
want a backup to share your workload and for hand-off at times like
this?

You've been carrying the load of linux-next alone for years now, and
having someone that can take over every now and then seems like a good
idea. You've been doing an outstanding job but everybody need downtime
sometimes.

Linux-next is incredibly valuable for _so_ many of us, and a big part
of the value is in the continuous frequent releases that allows us to
catch issues quickly when they are staged, and keep bisectability as
high as possible. It also helps us discover early on when someone is
merging code through a maintainer they shouldn't (due to conflicts).
It will be very much missed during your well-deserved vacation.


-Olof
