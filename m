Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3LEKsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:48:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58162 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab3LEKsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:48:22 -0500
Date: Thu, 5 Dec 2013 11:48:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unnecessarily gendered language
Message-ID: <20131205104808.GA6455@amd.pavel.ucw.cz>
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-12-02 20:18:52, Matthew Garrett wrote:
> The kernel as a number of cases of gendered language. The majority of these
> refer to objects that don't have gender in English, and so I've replaced
> them with "it" and "its". Some refer to people (developers or users), and
> I've replaced these with the singular "they" variant. Some are simply
> typos that I've fixed up.

Why is this good idea?

I don't think this makes documentation better.

> @@ -127,7 +127,7 @@ gid=
>  umask=			Provide default owner, group, and access mode mask.
>  			These options work as documented in mount(8).  By
>  			default, the files/directories are owned by root and
> -			he/she has read and write permissions, as well as
> +			they have read and write permissions, as well as
>  			browse permission for directories.  No one else has any
>  			access permissions.  I.e. the mode on all files is by
>  			default rw------- and for directories rwx------, a

So... we had unambiguous text "user has read and write permissions"
and now you have to wonder if they refers to "user" or
"files/directories".

(And I'm pretty sure most people will parse it the wrong way.)

> @@ -23,7 +24,7 @@ Quota netlink interface
>  When user exceeds a softlimit, runs out of grace time or reaches hardlimit,
>  quota subsystem traditionally printed a message to the controlling terminal of
>  the process which caused the excess. This method has the disadvantage that
> -when user is using a graphical desktop he usually cannot see the message.
> +when user is using a graphical desktop they usually cannot see the
>  message.

Is this even correct english?


NAK, FWIW.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
