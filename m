Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaAXK1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:27:42 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:42491 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaAXK1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:27:40 -0500
Date: Fri, 24 Jan 2014 02:27:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mike Waychison <mikew@google.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware/google: drop 'select EFI' to avoid recursive
 dependency
In-Reply-To: <1390521727.32356.16.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1401240221370.9846@chino.kir.corp.google.com>
References: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org> <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com> <20140123134910.144a70cc0fd4c02ba0f14de4@linux-foundation.org> <alpine.DEB.2.02.1401231444510.26509@chino.kir.corp.google.com>
 <1390521727.32356.16.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014, Joe Perches wrote:

> > > get_maintainer's default output should answer the question "who do I
> > > email about this file", and that ain't working :(
> 
> Complaints cheerfully ignored.
> Suggestions gratefully accepted.
> 
> Files that haven't had changes in a long time
> generally aren't maintained.
> 
> Old addresses frequently become stale and bounce.
> 
> It'd be better if there was a MAINTAINERS entry
> for drivers/firmware/google.
> 

I think scripts/get_maintainer.pl is only really useful for emailing 
patches so I think outputting at least somebody to cc on patches would be 
a good idea.  It doesn't necessarily need to be someone who maintains the 
code and pushes it to Linus.

I'm not sure how much runtime is a factor for people of the script, but 
falling back to git-blame behavior to at least get one or two cc's sounds 
appropriate.  If the email address is outdated, owell, we live and learn.

Otherwise it just seems like people would throw patches at a wall and see 
which ones stick.

Now, if Andrew wants an all-encompasing MAINTAINERS entry that really 
lists all the directories he maintains, that would be fine as well just as 
long as we're ok with the size of MAINTAINERS doubling :)
