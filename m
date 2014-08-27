Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaH0JcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:32:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43089 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbaH0JcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:32:15 -0400
Date: Wed, 27 Aug 2014 11:32:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Janek Kozicki <janek_listy@wp.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [HELP (not patch)] Re: Resume from hibernation fails 40% of
 time, kernel 3.16.0 (64GB of RAM, 32 Xeon E5-2687W cores)
Message-ID: <20140827093213.GA30622@amd>
References: <20140804185644.05a56986@absurd>
 <20140804232447.5094b23e@absurd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804232447.5094b23e@absurd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-08-04 23:24:47, Janek Kozicki wrote:
> I see that this list is extremely busy, I thought this is the
> place to go asking for help in debugging hibernation. If that's not
> the right place, please tell me where should I go. If that's the
> right place, please get me started. First - how can I retrieve some
> useful logs from failed resume attempts?

You want to cc rjw.

> > The failure was always a reboot after resume had almost succeeded. In
> > cases when there was a success there was a ---[cut here]--- part
> > which is in the attachment. All of my successes are included in the
> > attachments (please note that method had 0 success rate, so no
> > success logs are attached for it).

Usually trying with minimum set of drivers loaded is useful debug
technique. Plus there are some debugging hints in Documentation/.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
