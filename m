Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaLQFO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 00:14:57 -0500
Received: from imap.thunk.org ([74.207.234.97]:60133 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbaLQFO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 00:14:56 -0500
Date: Wed, 17 Dec 2014 00:14:24 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Borislav Petkov <bp@alien8.de>
Cc: Kevin Cernekee <cernekee@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>, gnomes@lxorguk.ukuu.org.uk,
        Brian Norris <computersforpeace@gmail.com>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/4] Stop maintainer abuse
Message-ID: <20141217051424.GZ17575@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Borislav Petkov <bp@alien8.de>, Kevin Cernekee <cernekee@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>, gnomes@lxorguk.ukuu.org.uk,
	Brian Norris <computersforpeace@gmail.com>,
	torvalds@linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
 <20141216130939.166c4369@lwn.net>
 <CAJiQ=7B76vE2ctYd2GK5+_whNnLGKtUY65qkMLdewBqfO7HfPg@mail.gmail.com>
 <20141216223133.GB5656@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216223133.GB5656@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:31:33PM +0100, Borislav Petkov wrote:
> On Tue, Dec 16, 2014 at 02:19:02PM -0800, Kevin Cernekee wrote:
> > In the current process, many submitters do not know their maintainer's
> > policy until they get in trouble for violating it.
> 
> Just say what Christoph suggested: people should not expect any feedback
> during the merge window. If they get some, fine. It can't get any
> simpler than that.

Or during the week of Plumber's Conference... or LSF/MM... or the
during the Kernel Summit...  or if they are in transit to
Linux.conf.au....  sometimes a patch submitter won't get feedback
right away.  It's nothing personal.

With all due respect to Steven, I think he over-reacted a little with
his "maintainer abuse" reply.  Most of the time people won't get
"yelled" at if they send patches at the wrong time.  And what's wrong
for one maintainer will be right for another, and vice versa.

					- Ted
