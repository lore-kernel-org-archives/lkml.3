Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab3ICAni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:43:38 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:46756 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3ICAnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:43:37 -0400
Message-ID: <1378169449.32763.347.camel@haakon3.risingtidesystems.com>
Subject: Re: Linux 3.11
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Sep 2013 17:50:49 -0700
In-Reply-To: <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
	 <1378161032.32763.341.camel@haakon3.risingtidesystems.com>
	 <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 15:50 -0700, Linus Torvalds wrote:
> On Mon, Sep 2, 2013 at 3:30 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > Unfortunately, this doesn't include the remaining target fixes for
> > v3.11:
> >
> > Re: [GIT PULL -v2] target fixes for v3.11
> > http://marc.info/?l=linux-kernel&m=137799048226191&w=2
> >
> > Is there a reason why these did not get PULLed..?
> 
> Very simple: I have no such email in my mailbox. I see the "target
> updates for v3.11-rc1" email (and I pulled that), and there is nothing
> since.
> 
> I don't even have that mail in my lkml archives, much less as a private email.
> 
> I see neither youe "-v2 PULL request" nor the "One more late v3.11
> specific regression" one. In fact, I see no emails from you at all
> from Aug 31.
> 
> It may be that gmail hates you for some reason...
> 
> [ time passes ]
> 
> Yup. It's in my spam-box, with gmail helpfully telling me:
> 
>    Why is this message in Spam? We've found that lots of messages from
> linux-iscsi.org are spam.  Learn more
> 
> so something is rotten in the state of linux-iscsi.org.
> 
> Recent messages from you were similarly tagged:
> 
>  "[GIT PULL -v2] target fixes for 3.11"
>  "Re: LIO FC Target"
>  "Re: [GIT PULL] target fixes for v3.11-rc7"
> 
> there might have been more. You might want to try to figure out why
> gmail thinks that linux-iscsi.org is spammy.

Mmmm, that is what I was afraid of, looking into that now..

So if you would, please go ahead and pull target-pending/master ASAP for
the fixes, and I'll send the parts that need to goto Greg-KH separately.

Thanks,

--nab

