Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaICDba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:31:30 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:38099 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaICDb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140902160841.GA5001@linux.vnet.ibm.com>
References: <1408972138-12246-1-git-send-email-bobby.prani@gmail.com>
 <53FF8B77.7000103@infradead.org> <20140828210010.GM5001@linux.vnet.ibm.com>
 <CAJhHMCDxsukXe_HW55iJp0oCAWgrosxCRX1AfocS6QBzxaD0pw@mail.gmail.com>
 <20140828213945.GP5001@linux.vnet.ibm.com> <CAJhHMCDaMH0b0Np8vNf=RBH8i76AUK78qf213aWfHY-F4j3OOw@mail.gmail.com>
 <20140902160841.GA5001@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 2 Sep 2014 23:30:57 -0400
Message-ID: <CAJhHMCBDbm-pe1BefM7giD-bLBnigdNTcNcYYLBA-zBaARpjEw@mail.gmail.com>
Subject: Re: [PATCH] doc: memory-barriers.txt: Correct example for reorderings
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 12:08 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:

> Could you please adjust in this way?  Again, the point is to be the
> first few items in a full set of permutations, not to illustrate selected
> orderings/outcomes.
>

OK, if that is the case then replacing x with y is much easier. I will
send an updated patch. Thanks!

-- 
Pranith
