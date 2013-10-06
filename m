Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3JFVdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:33:16 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37862 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3JFVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:33:15 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 6 Oct 2013 14:33:09 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131006213309.GO19510@leaf>
References: <20131005184307.GA6429@leaf>
 <1380999108.2081.138.camel@joe-AO722>
 <20131006062739.GA5218@kroah.com>
 <20131006211855.GB19510@leaf>
 <1381094837.2081.160.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381094837.2081.160.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 02:27:17PM -0700, Joe Perches wrote:
> On Sun, 2013-10-06 at 14:18 -0700, Josh Triplett wrote:
> > On Sat, Oct 05, 2013 at 11:27:39PM -0700, Greg Kroah-Hartman wrote:
> > > On Sat, Oct 05, 2013 at 11:51:48AM -0700, Joe Perches wrote:
> > > > On Sat, 2013-10-05 at 11:43 -0700, Josh Triplett wrote:
> > > > > Kernel maintainers reject new instances of the GPL boilerplate paragraph
> > > > > directing people to write to the FSF for a copy of the GPL, since the
> > > > > FSF has moved in the past and may do so again.
> []
> > any objections to merging the patch in its current form?
> 
> Your own suggestion that this be applied only to
> patches hasn't been implemented.

Given Greg's comment that we want to eliminate the existing instances, I
wanted to make sure implementing that change still makes sense.

I can easily enough make checkpatch emit an ERROR for patches and a WARN
or CHK for existing files, if that's the consensus.

- Josh Triplett
