Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab3HZMzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:55:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42051 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab3HZMzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:55:00 -0400
Date: Mon, 26 Aug 2013 14:54:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Clements <paul.clements@steeleye.com>,
        linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net
Subject: Re: [PATCH] nbd: correct disconnect behavior
Message-ID: <20130826125459.GB20329@amd.pavel.ucw.cz>
References: <20130626162107.9237360f7646ec25f23cf5aa@linux-foundation.org>
 <1372749578.5019.8@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372749578.5019.8@driftwood>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> --- a/include/linux/nbd.h
> >> +++ b/include/linux/nbd.h
> >> @@ -41,6 +41,7 @@ struct nbd_device {
> >>  	u64 bytesize;
> >>  	pid_t pid; /* pid of nbd-client, if attached */
> >>  	int xmit_timeout;
> >> +	int disconnect; /* a disconnect has been requested by user */
> >>  };
> >
> >The cool kids are using bool lately ;)
> 
> No, they're not. The C++ guys and stuffy old ex-cobol types are, and
> think it helps. (Does any architecture anywhere _not_ use int for
> bool?)

Its useful as documentation, and while it is probably int,
faster/smaller code can probably generated in some cases.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
