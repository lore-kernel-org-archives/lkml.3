Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbaIKPvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:51:03 -0400
Received: from imap.thunk.org ([74.207.234.97]:51290 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003AbaIKPu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:50:59 -0400
Date: Thu, 11 Sep 2014 11:50:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
Message-ID: <20140911155053.GF26178@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Peter Hurley <peter@hurleysoftware.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1410384499-4982-1-git-send-email-peter@hurleysoftware.com>
 <20140911000343.GA5328@kroah.com>
 <5410E8A2.5030802@hurleysoftware.com>
 <20140911002410.GA11732@kroah.com>
 <5410F08D.10707@hurleysoftware.com>
 <20140911135610.GD15632@thunk.org>
 <5411C264.8000105@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411C264.8000105@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 11:40:20AM -0400, Peter Hurley wrote:
> 
> This is the basic interpretation I assumed, and most of what the tty core
> already did.

Yes, I know.  :-)

So it's been a long time since I've had anything to do with the tty
code, but FWIW, I'd agree with merging Peter's patch.

Cheers,

					- Ted
