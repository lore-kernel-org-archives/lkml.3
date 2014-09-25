Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaIYFAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:00:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42031 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaIYFAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:00:07 -0400
Date: Thu, 25 Sep 2014 06:00:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Elshad Mustafayev <elshadimo@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: acctc.c: Fixed else if not generally userful
 after a break or return warning
Message-ID: <20140925050004.GM7996@ZenIV.linux.org.uk>
References: <E1XX0bN-00032o-0x@feisty.vs19.net>
 <1411619466.4026.2.camel@joe-AO725>
 <CAAm9=9QeO_VtdY+fJ5JbrBhN52z=JUeU09Nh3Mp04QWf+Qyygw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAm9=9QeO_VtdY+fJ5JbrBhN52z=JUeU09Nh3Mp04QWf+Qyygw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:34:11AM -0400, Elshad Mustafayev wrote:
> I am sorry if I disturbed you. I just follow the steps in kernel newbies to
> get me in kernel development.

It's not you, it's checkpatch.pl plus the fairly common tendency to give
that thing a lot more respect than it deserves...

Basically, it's OK as a tool that draws ones attention to a subset of
code that might or might not be worth looking at; it gives both false
positives and false negatives and as long as there's not too much of those,
it's useful.  Provided that it does *not* replace one's taste.  I.e. "hey,
it points to these lines; let's take a look, some of those might be
worth some attention", rather than "The Most Holy Oracle Has Spoken;
Do What It Says".
