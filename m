Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbbAQIBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 03:01:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55659 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbbAQIBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 03:01:40 -0500
Date: Sat, 17 Jan 2015 09:01:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] out out damn perl
Message-ID: <20150117080136.GA7396@amd>
References: <54AC72AF.5090609@landley.net>
 <20150106155024.5efa209d575fff4868758482@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106155024.5efa209d575fff4868758482@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue 2015-01-06 15:50:24, Andrew Morton wrote:
> On Tue, 06 Jan 2015 17:41:35 -0600 Rob Landley <rob@landley.net> wrote:
> 
> > Commit e6023367d779 added perl back to the kernel build in -rc6.
> > Replace 39 lines of perl with 4 lines of shell script.
> 
> Please resend this:
> 
> - Express the commit in the conventional fashion
> 
>   e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
> 
>   - So that we all don't have to go look up the commit to find out
>     what happened.
> 
>   - So people can look up the commit in other trees, where the hash
>     might change.
> 
> - Cc the people who wrote and committed the patch.
> 
> - The offending commit has cc:stable, so have a think about adding a
>   cc:stable to this one as well.

Actually, I don't think this should go to stable. I like the patch,
but it is not a bug, and certainly not serious enough one.

> - The title is cute, but not terribly informative.

Cute :-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
