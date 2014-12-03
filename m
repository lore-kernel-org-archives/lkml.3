Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaLCKlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:41:51 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50927 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaLCKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:41:49 -0500
Date: Wed, 3 Dec 2014 11:41:44 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Alex Dubov <alex.dubov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
Message-ID: <20141203104144.GA7495@localhost.localdomain>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
 <1417494919-4577-2-git-send-email-oakad@yahoo.com>
 <20141202170037.GG29748@ZenIV.linux.org.uk>
 <CAPs88r8m2QmaOWy623swGk=T3cyG85X3N7Z9tAp3nZvD0Tch+A@mail.gmail.com>
 <1417589446.5303.121.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141203080800.GB5193@localhost.localdomain>
 <CAFLxGvzZQ59BRdWiPyVhCEUrR2UD3Ozdg2DHzRUqNQocf9o-EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzZQ59BRdWiPyVhCEUrR2UD3Ozdg2DHzRUqNQocf9o-EA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 09:17:37AM +0100, Richard Weinberger wrote:
> Come on guys, get a cup of coffee and relax a bit...

I am relaxed, especially after I had a good laugh reading this:

   On a less related note, I hope you will agree that the simpler
   mechanism for this very in-demand feature is long overdue on Linux
   (every man and his dog are passing fds around these days).

Really, in years and years of unix programming, I have not yet felt
the need to pass a file descriptor. Thats goes double for my dogs.

In any case, I find it hard to believe that the traditional method is
really so bad. The explanation of why this new way is needed boils
down to: "unix programming is so hard to get right."

Thanks,
Richard
