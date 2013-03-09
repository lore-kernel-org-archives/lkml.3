Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab3CIAaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:30:18 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:59696 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947Ab3CIAaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:30:16 -0500
MIME-Version: 1.0
In-Reply-To: <20130309001917.GA6015@redhat.com>
References: <20130308193652.GA11692@redhat.com> <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
 <20130308210432.GA21500@redhat.com> <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
 <20130308230734.GA28317@redhat.com> <CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
 <20130308233041.GA32587@redhat.com> <CA+55aFxBvyLcWJB0JMNcaCXHtgvPLt3cFQqJeRFcb=6rkZFtvA@mail.gmail.com>
 <20130308235514.GA5605@redhat.com> <CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
 <20130309001917.GA6015@redhat.com>
From: Raymond Jennings <shentino@gmail.com>
Date: Fri, 8 Mar 2013 16:29:33 -0800
Message-ID: <CAGDaZ_rZfUZc6DWsS1+abmFCMYDpD27-Ryva2R4nuq_cA3-cBw@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 4:19 PM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Mar 08, 2013 at 04:02:02PM -0800, Linus Torvalds wrote:
>  > On Fri, Mar 8, 2013 at 3:55 PM, Dave Jones <davej@redhat.com> wrote:
>  > >
>  > > That one was printed out with %s
>  >
>  > Ok, so those random pathnames you generate? They're funky.
>
> I just did a test with just a page of 'A's, and got the same result,
> so while that unicode stuff looks fancy, it isn't necessary to tickle
> these bugs.
>
> Trying to figure out exactly what change I made that started triggering this.

Just curious but is this bug present in 3.7?  3.6?  etc?

I'm actually a bit curious how "old" old is in this case.


>         Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
