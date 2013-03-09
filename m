Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab3CIATX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:19:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab3CIATW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:19:22 -0500
Date: Fri, 8 Mar 2013 19:19:17 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130309001917.GA6015@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130308193652.GA11692@redhat.com>
 <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
 <20130308210432.GA21500@redhat.com>
 <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
 <20130308230734.GA28317@redhat.com>
 <CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
 <20130308233041.GA32587@redhat.com>
 <CA+55aFxBvyLcWJB0JMNcaCXHtgvPLt3cFQqJeRFcb=6rkZFtvA@mail.gmail.com>
 <20130308235514.GA5605@redhat.com>
 <CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 04:02:02PM -0800, Linus Torvalds wrote:
 > On Fri, Mar 8, 2013 at 3:55 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > That one was printed out with %s
 > 
 > Ok, so those random pathnames you generate? They're funky.

I just did a test with just a page of 'A's, and got the same result,
so while that unicode stuff looks fancy, it isn't necessary to tickle
these bugs.

Trying to figure out exactly what change I made that started triggering this.

	Dave

