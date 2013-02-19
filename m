Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3BUBBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:01:49 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:51799 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3BUBBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:01:47 -0500
Date: Tue, 19 Feb 2013 11:44:10 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: update top level 00-INDEX file with new
 additions
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <51224F70.9050806@infradead.org> (from rdunlap@infradead.org on
	Mon Feb 18 09:57:36 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361295850.29465.8@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 09:57:36 AM, Randy Dunlap wrote:
> On 02/18/13 01:39, Jiri Kosina wrote:
> > On Thu, 14 Feb 2013, Paul Gortmaker wrote:
> >
> >> It seems there are about 80 new, but undocumented addtions at
> >> the top level Documentation directory.  This fixes up the top
> >> level 00-INDEX by adding new entries and deleting a couple orphans.
> >> Some subdirs could probably still use a check/cleanup too though.
> 
> After this patch, I would prefer to see a requirement that each  
> Documentation/
> file contain a "topic" line and then generate INDEX files from those  
> automatically...
> 
> comments?

I actually have a script that can audit the 00-INDEX files, as part of  
my kernel.org/doc build stuff:

   http://landley.net/hg/kdocs/file/tip/make

Manually auditing these isn't hard for me, it's just that since  
kernel.org went all-in on locking the barn door after the horses  
escaped, I haven't had access to my old kernel.org account (I need to  
meed kernel developers in person to get keys signed, which doesn't  
happen much).

And even if I did get a new ssh key, you don't get shell access anymore  
you get "kup" which is a git wrapper you can't rsync through. So fixing  
problem 1 opens up problem 2 and I still can't do anything useful.  
(Navigating the new bureaucracy is on my todo list, but not really  
something I sit down and go "oh boy, I should work on THIS" on any  
given evening.)

So I haven't been able to update kernel.org/doc since the breakin, and  
my tools for auditing the 00-INDEX files and htmldocs and menuconfig  
and so on are all tied up with that.

Rob