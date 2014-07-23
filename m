Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbaGWQHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:07:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:47404 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756662AbaGWQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:07:51 -0400
X-Greylist: delayed 5440 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2014 12:07:50 EDT
Date: Wed, 23 Jul 2014 12:07:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: Levente Kurusa <lkurusa@redhat.com>, Tony Luck <tony.luck@gmail.com>,
        =?ISO-8859-1?B?Qmr4cm4=?= Mork <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
Message-ID: <20140723120748.5ef6e1b5@gandalf.local.home>
In-Reply-To: <CAPDOMVh+zVQZQWjS1mTDmZo9frvk9t+kzN4_cOaoDgaNePF2AA@mail.gmail.com>
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
	<874my98p6u.fsf@nemi.mork.no>
	<CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
	<CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
	<CAAsK9AGtdJiz0xnmfqLBAqxmt=r+WANsmxwB_vQ3O5aKzMW1LQ@mail.gmail.com>
	<CAPDOMVhj72TFKbtw_93juX19WVdfUzh3KM9tCEjbTdUZvUfcUQ@mail.gmail.com>
	<20140722193350.GA486@home.goodmis.org>
	<CAPDOMVipLiXuYqndO_gnMYocDLVsHX9zcTdSMUV_EjJo72nx6w@mail.gmail.com>
	<20140723103707.64071c00@gandalf.local.home>
	<CAPDOMVh+zVQZQWjS1mTDmZo9frvk9t+kzN4_cOaoDgaNePF2AA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 11:35:21 -0400
Nick Krause <xerofoify@gmail.com> wrote:

> Steve, I  have make a few mistakes. That doesn't give you the right to
> put me under a waste of time yet.

Nobody is upset at you for making a few mistakes. But ignoring advice
from people is something quite different, and that is what tends to
piss people off.

You were told time and time again to stop this fixme craze because you
obviously didn't know the details of what you were fixing, but you
continued to care on. The issue is with these patches that you probably
caught a maintainer off guard, and they just accepted it thinking you
had some clue to the code you were fixing. Thus, not only are you
removing crucial comments about areas of code that needs more
attention, you end up making things worse. Your actions are dangerous to
the kernel and the fact you ignoring everyone telling you to stop it,
makes you dangerous to the kernel. That gives me the right to put you
under the "waste of time" folder.

Now it may seem that I'm being rather harsh to you, and I may be. The
Linux kernel is a serious project and it can not afford having to deal
with those that do not listen.

That said...

I see you stated in another email:

"Very well then I guess the community wants me to listen better to the
maintainers and not do stupid things"


Finally, you are listening.

You obviously are very enthusiastic, and I would like you not to waste
your own time and energy trying to help in a not so helpful way. If you
really want to help the Linux community, here's what you do.

Find a single area to focus on. Not a key word throughout the kernel.
Look at the USB stack, or find some driver in staging that is for some
really cheap hardware that you can afford. And get it cleaned up and
working nicely. Start simple. Try to understand that area completely.

Remember, nobody understand every aspect of the kernel. All the main
kernel developers are experts in select parts. I wouldn't even try
fixing "fixmes" in parts of the kernel that I'm unfamiliar with.

Find a part of the kernel, and learn every aspect of that part inside
and out. Study the code. Boot the kernel. Make a modification of that
code and see what happens. Yes! Break it (but don't submit a patch that
does ;). Sometimes breaking stuff is the best way to understand why it
worked in the first place. Use function graph tracing to see the code
flow.

After you have done that, and you really have a good understanding of
that part of the kernel, you should in the mean time see a way to
enhance it, or better yet, find a real bug and fix it. Then you can
submit a patch and that will be something of use.

Moral of the story: Learn the kernel before submitting a patch, do not
submit a patch to help you learn the kernel.

-- Steve
