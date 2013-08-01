Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab3HAXso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:48:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38638 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751627Ab3HAXsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:48:42 -0400
Message-ID: <1375400915.2034.91.camel@joe-AO722>
Subject: Re: [PATCH] Staging: wlags49_h2: fixed 80 line character and white
 space issue in ap_h2.c Fixed various coding style warnings found by the
 checkpatch.pl tool
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Evan Ng <evan.sin.ng@gmail.com>, pe1dnn@amsat.org, johanmeiring@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 01 Aug 2013 16:48:35 -0700
In-Reply-To: <20130801222840.GA5444@kroah.com>
References: <1375303465-3437-1-git-send-email-evan.sin.ng@gmail.com>
	 <20130801215019.GA4427@kroah.com>
	 <CAGkkOHezKfjYaGJHcbPPiE4EobOLMp=K62-NWhpbvp2QDhLOfA@mail.gmail.com>
	 <20130801222840.GA5444@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 06:28 +0800, Greg KH wrote:
> On Thu, Aug 01, 2013 at 03:08:21PM -0700, Evan Ng wrote:
> > Thanks for the reply, 
> > 
> > Being this is my first patch that I have submitted, I want to clarify a few
> > things:
> > 
> > My *corrected* subject should read something like this? 
> > 
> > "Subject: [PATCH] Staging: wlags49_h2: fixed 80 line character and white space
> >                issue in ap_h2.c Fixed various coding style warnings found by
> > the
> >                checkpatch.pl tool
> > \n
> > LONGER DESCRIPTION GOES HERE"
> 
> No.
> 
> It should be:
> 	Subject: [PATCH] Staging: wlags48_h2: ap_h2.c: fixed tab whitespace issue
> 
> 	This patch fixes the tab vs. spaces white space issues in this
> 	file.
> 
> 	Signed-off-by: ....

> > As for the doing "one thing at a time" would it be preferred if I fix the
> > syntax of one function within a file a time?  Would that mean that for one
> > simple .c file I could be making 15 or so commits to it?
> 
> How about fixing one specific warning at a time for the whole file?
> Like tab issues, and then { issues, and then ' ' issues, and so on.  See
> the archives of the mailing list for lots of examples of how to do this
> properly.

Another possibility is to do all the individual line
whitespace changes in a single patch like trailing spaces,
spaces to tabs, pointer positioning, spaces after
if/while/do/for, etc.

Make sure these changes don't add or delete lines.

Use "git diff -w" to make sure that are no other changes.

Verify that the objects do not change before and after
the change.

That way you don't have to touch the same line multiple
times with all the different types of whitespace changes.

Submit that single patch then do other changes like
80 column wrapping if that sort of change appeals to you.


