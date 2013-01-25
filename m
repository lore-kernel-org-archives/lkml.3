Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3AYCOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:14:52 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:45368 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab3AYCOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:14:43 -0500
Date: Thu, 24 Jan 2013 21:14:37 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Valdis.Kletnieks@vt.edu
Cc: Chen Gang <gang.chen@asianux.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Consult] Plan: personal contributes plan for 2013
Message-ID: <20130125021437.GA28908@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
	Chen Gang <gang.chen@asianux.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50FFCA59.5070903@asianux.com>
 <30811.1359070263@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30811.1359070263@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 06:31:03PM -0500, Valdis.Kletnieks@vt.edu wrote:
> >
> > 10 patches per month: (at least)
> 
> Even Dave Miller only averages 12-15 patches a month, and he does it
> for a living, and they're all in the one part of the kernel he
> maintains.  It's going to be a really hard time for a newcomer to
> get up to speed enough to produce a useful and usable patch every 3
> days on the average, especially across multiple areas of the kernel.

Just to be curious, I checked the number of commits I've done in the
past 12 months, and it's 99, for an average of a bit over 8 patches a
month.  (via "git log --author=tytso --since="1 year ago" --oneline |
wc -l")

More importantly, it's important to shoot for quality, not quantity.
10 patches a month which fixes whitespaces in code that you're not
touching anyway just generates work for maintainers without materially
improving the quality of the kernel.

	      				- Ted
