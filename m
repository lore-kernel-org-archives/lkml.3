Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaLNH1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 02:27:00 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:44777 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLNH06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 02:26:58 -0500
MIME-Version: 1.0
In-Reply-To: <20141214175747.2e6c506e@canb.auug.org.au>
References: <20141214175747.2e6c506e@canb.auug.org.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 13 Dec 2014 23:26:36 -0800
Message-ID: <CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
Subject: Re: linux-next: question about the luto-misc tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2014 10:58 PM, "Stephen Rothwell" <sfr@canb.auug.org.au> wrote:
>
> Hi Andy,
>
> The luto-misc tree seems to have a whole series of commits in it that
> have just bee removed from the rcu tree ...  You really have to be very
> careful if you base your work on a tree that is regularly rebased.

Hmm.  They were there a couple days ago.  Paul, what should I do about
this?  I only need the one NMI nesting change for the stuff in
luto/next.

>
> I also wonder if the other commits in that tree are destined for
> v3.19?  If they are for v3.20, then they should not be in linux-next
> until after v3.19-rc1 has been released.

They're for 3.20.  I'll drop the whole series from the next branch for now.

--Andy

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
