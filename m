Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaCDKKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:10:53 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:40468 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbaCDKKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:10:47 -0500
Date: Tue, 4 Mar 2014 11:08:04 +0100
From: Henrik Austad <henrik@austad.us>
To: "Gideon D'souza" <gidisrael@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-mentors-owner@selenic.com
Subject: Re: Is there any list for newbie bugs?
Message-ID: <20140304100804.GC18178@austad.us>
References: <CAPNrq4xd-fdStjz+BPT4z8FMCsiBH51CpozJjwDrY3x4F6qHgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPNrq4xd-fdStjz+BPT4z8FMCsiBH51CpozJjwDrY3x4F6qHgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 03:10:54PM +0530, Gideon D'souza wrote:
> Hey All,
> 
> In my quest for work in the linux kernel I was looking at bugs.
> 
> While I have a general idea of the kernel (including KDB) most of the
> bugs I've seen (under process management and drivers) are very
> contrived to me.
> 
> I was wondering if there is anything like a good_first_bug or
> newbie_bug list anywhere?
> 
> If not, anyone out there know any bugs a kernel toddler can try and attack?

As with anything, the simple bugs tend to be removed quite quickly, I don't 
think many kernelhackers leave the easy bugs "just to be nice to newbies" -
whenever a bug is discovered they are fixed.

However, I discovered http://eudyptula-challenge.org/ a little while ago.
Be warned, I haven't tested it, not sure what the challenge is like, but 
might as well be a good place to start.

Good luck!

-- 
Henrik Austad
