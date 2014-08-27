Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbaH0LUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:20:10 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:37893 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbaH0LUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:20:07 -0400
Date: Wed, 27 Aug 2014 13:19:58 +0200
From: Janek Kozicki <janek.listy.mailowe@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [HELP (not patch)] Re: Resume from hibernation fails 40% of
 time, kernel 3.16.0 (64GB of RAM, 32 Xeon E5-2687W cores)
Message-ID: <20140827131958.37e9df8b@absurd>
In-Reply-To: <20140827093213.GA30622@amd>
References: <20140804185644.05a56986@absurd>
	<20140804232447.5094b23e@absurd>
	<20140827093213.GA30622@amd>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, my problem is currently on bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=82291

and I hope that we are making some progress there.

best regards
Janek Kozicki



Pavel Machek said:     (by the date of Wed, 27 Aug 2014 11:32:13 +0200)

> On Mon 2014-08-04 23:24:47, Janek Kozicki wrote:
> > I see that this list is extremely busy, I thought this is the
> > place to go asking for help in debugging hibernation. If that's not
> > the right place, please tell me where should I go. If that's the
> > right place, please get me started. First - how can I retrieve some
> > useful logs from failed resume attempts?
> 
> You want to cc rjw.
> 
> > > The failure was always a reboot after resume had almost succeeded. In
> > > cases when there was a success there was a ---[cut here]--- part
> > > which is in the attachment. All of my successes are included in the
> > > attachments (please note that method had 0 success rate, so no
> > > success logs are attached for it).
> 
> Usually trying with minimum set of drivers loaded is useful debug
> technique. Plus there are some debugging hints in Documentation/.
> 
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 

