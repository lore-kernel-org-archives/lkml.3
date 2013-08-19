Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab3HSPwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab3HSPwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:52:07 -0400
Date: Mon, 19 Aug 2013 17:52:02 +0200
From: Anton Arapov <anton@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ATTEND] oops.kernel.org prospect
Message-ID: <20130819155202.GF19070@bandura.laptop>
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819153939.GA23875@thunk.org>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 11:39:39AM -0400, Theodore Ts'o wrote:
> On Mon, Aug 19, 2013 at 05:16:43PM +0200, Anton Arapov wrote:
> > > Why not just do that through email?  You'll reach a much wider group of
> > > people than the tiny 80 developers at the conference.
> > 
> > Ouch! Someone to take it as replacement of email - the least I wanted. It will
> > go email-way in either case.
> > 
> > These tiny 80 may give the most valuable feedback on the topic. And often
> > it is the most difficult to get attention of them, especially via email.
> > In case it fits the conference, it could dilute the heavy topics.
> 
> Usyually the best thing to do is to start the discussion on the
> mailing list (and we can do that on ksummit-2013-discuss, but this is
> always why it's sometimes useful to cc lkml on topic proposals, so we
> can jump start the discussion), and see if it's controversial or not.

Oh well,... I didn't have a time for this right now, nor project is
not exactly in the state I'm willing to show (mostly webui) 

// CC'd: lkml (please don't complain on styles yet, focus on functionality)

> I suspect the biggest issue is one of "who will bell the cat".  As in,
> if no one creates a new oops.kernel.org, and if we can't get the
> community distributions to be willing to set up their systems to
> automatically submit oops reports to the server, it's going to be
> somewhat pointless to have the discussion at the kernel summit.

It is created and distributions are willing to submit oopses
automatically. Debian, Fedora, Ubuntu are already sending reports.

The above is exactly what I would be able to share on conference with
more details.

> Note that main value of oops.kernel.org is the fact that we find out
> which bugs are most likely hitting "real users", as opposed to the
> very valuable testing done by developers on the linux-next and -rc
> kernels.  It's main drawback is that for privacy reasons, we don't get
> much more information than the stack trace.  So if it's just
> linux-next testers and developers using oops.kernel.org, who are the
> people who are more likely able to submit a detailed bug report, the
> oops.kernel.org server probably won't add much value.  In fact, if the
> testers depend on the sending of an anonymous stack trace, and don't
> send us more detailed reproduction information, the existence of
> oops.kernel.org could actually make things worse.

And the above here is one of the feedbacks I am willing to see. As well as
ideas how to overcome it.

> This means, realistically, it needs someone from Fedora or Open SuSE
> or Debian or Ubuntu being willing to sponsor the uploading of
> information to oops.kernel.org by default.
...up and running, now...

hth,
--
Anton
