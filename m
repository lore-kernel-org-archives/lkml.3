Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3KQS3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 13:29:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50347 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3KQS3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 13:29:22 -0500
Date: Sun, 17 Nov 2013 19:29:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Maximiliano Curia <maxy@gnuservers.com.ar>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org,
        Margarita Manterola <margamanterola@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
Message-ID: <20131117182906.GE30012@xo-6d-61-c0.localdomain>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
 <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com>
 <201309030717.57866.a.miskiewicz@gmail.com>
 <201310241800.18490.a.miskiewicz@gmail.com>
 <20131029135036.GA30992@gnuservers.com.ar>
 <5270EBA9.6070302@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5270EBA9.6070302@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed 2013-10-30 07:21:13, Peter Hurley wrote:
> On 10/29/2013 09:50 AM, Maximiliano Curia wrote:
> >??Hola Arkadiusz!
> >
> >El 2013-10-24 a las 18:00 +0200, Arkadiusz Miskiewicz escribió:
> >>Was just going over bug-readline and lkml archives and found no continuation
> >>of this.
> >
> >>There was a patch proposed but didn't get applied.
> >>https://lkml.org/lkml/2013/8/17/31
> >>Maybe it only needs proper patch submission?
> >
> >The latest patch is: https://lkml.org/lkml/2013/9/3/539
> >
> >And the latest reply is: https://lkml.org/lkml/2013/9/11/825
> >
> >Where Peter Hurley suggests that the patch needs a complete and detailed
> >analysis, but sadly I'm still not sure how to provide it. If anybody is up for
> >the task, by all means, go ahead.
> 
> The analysis is on my TODO list. I'll include it with a proper patch, this or
> next weekend.

Any news?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
