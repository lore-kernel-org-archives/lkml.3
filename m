Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaL3DsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:48:13 -0500
Received: from imap.thunk.org ([74.207.234.97]:46116 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaL3DsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:48:11 -0500
Date: Tue, 30 Dec 2014 03:48:07 +0000
From: tytso@mit.edu
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: nick <xerofoify@gmail.com>, jfs-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: Remove TO DO in jfs_xtree.c
Message-ID: <20141230034807.GA12551@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Kleikamp <dave.kleikamp@oracle.com>,
	nick <xerofoify@gmail.com>, jfs-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <549F55AC.9040308@gmail.com>
 <54A1D211.4080609@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A1D211.4080609@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 04:13:37PM -0600, Dave Kleikamp wrote:
> On 12/27/2014 06:58 PM, nick wrote:
> > Greetings Dave,
> > I am wondering why there is a TO DO above this code:
> >         * ToDo:  tlocks should be on doubly-linked list, so we can
> >         * quickly remove it and add it to the end.
> 
> I'm sure the idea was to avoid the for loop needed to find the previous
> entry in the linked list. A doubly-linked list makes it much simpler to
> remove an item from an arbitrary position in the list.

Hi Dave,

Just in case you weren't aware, Nick has been banned from the LKML
list for being a troll.

A common troll trick is to send e-mail to a number of individuals with
a mailing list (in this case, LKML) cc'ed, in the hopes that people
will reply, quoting the troll's words, so they can get around the
mailing list ban.

The reason why he has been banned is because he has apparently been
desperate to get _some_ patches into the Linux kernel.  Enough so that
he has proposed patches which do not compile, and/or were not tested
and/or for which he had no hardware (so he couldn't possibly have
tested it).

As a maintainer, you should be aware of his past history, and chose
for yourself whether, in the future, you feel you should respond to
any e-mail that he might send you.

Regards,

						- Ted

P.S.  Personally, the best reason for banning him isn't that he has
been wasting maintainers' time, but that he was responding to users
who were reporting bugs with nonsensical responses that were actively
harmful to users who were looking for help.
