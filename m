Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaLZSCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 13:02:13 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60053 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaLZSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 13:02:11 -0500
Date: Fri, 26 Dec 2014 10:02:06 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix multiple coding style issues
Message-ID: <20141226180206.GA3449@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1419597539-21254-1-git-send-email-kuleshovmail@gmail.com>
 <20141226142946.GA28213@newt.localdomain>
 <CANCZXo5wQhsxAbHypZqzaWPiakr9Mjbn-JCw+7+vW8vnmM2y9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANCZXo5wQhsxAbHypZqzaWPiakr9Mjbn-JCw+7+vW8vnmM2y9w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

On Fri, Dec 26, 2014 at 11:09:53PM +0600, Alexander Kuleshov wrote:
> Hello Jeremiah,
> 
> Thank you for feedback. It is my first patches to kernel, so i have a
> some little questions:
> 
I recommend checking out Greg Kroah Hartman's presentation on submitting
your first patch.  It has lots of good tips.

https://www.youtube.com/watch?v=LLBrBBImJt4

> > Jeremiah Mahler <jmmahler@gmail.com>:
> > Alexander,
> >
> > On Fri, Dec 26, 2014 at 06:38:59PM +0600, Alexander Kuleshov wrote:
> >
> > Your description needs to be more specific than just "coding style
> > fixes".  What type of problems did you fix?  How did you find them?
> >
> 
> There are some lines which more than 80 chars, I found it with
> scripts/checkpatch.pl.
> What is the best place to put this description? In commit message
> after first line?
> 

Yes, just put that in the log message.  The first line is the summary,
then a blank line, then the detailed log message.  The summary line is
what ends up in the subject line of the email.

> > Jeremiah Mahler <jmmahler@gmail.com>:
> > If you are looking for things to fix I suggest looking in the
> > drivers/staging directory.  There are lots of things that need to be
> > fixed in there.
> 
> So i must make this patch for kernel/git/gregkh/staging.git and resend
> it again or just to add to this thread?
> Or i'm wrong?
> 
You figured this out in your next message :)

> Thank you.

Glad I could help :)
-- 
- Jeremiah Mahler
