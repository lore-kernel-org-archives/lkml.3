Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaINQuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:50:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41349 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbaINQuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:50:21 -0400
X-Sasl-enc: Q1xIbM3h9b045ev/nZIS/rHry3t7etNOzzknJD6XQIn8 1410713419
Date: Sun, 14 Sep 2014 09:50:18 -0700
From: Greg KH <greg@kroah.com>
To: Sorin Facaoaru <work@sorin.cc>
Cc: ccross@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: ion: fix coding style
Message-ID: <20140914165018.GA2821@kroah.com>
References: <1410651970-3837-1-git-send-email-work@sorin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410651970-3837-1-git-send-email-work@sorin.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First off, thanks for the patches.

But, they need some tweaks before I can accept them.

You sent a bunch of patches, all with the same exact subject, with no
hint of which order they should be applied in, or what exactly they do.


On Sat, Sep 13, 2014 at 04:46:10PM -0700, Sorin Facaoaru wrote:
> - add line after declaration 
> - remove return statement in empty void function

For this patch, you are doing two different things, in the same file,
that should be two different patches.  But you might be able to merge
them with your other patches.

Make your patches do "just one thing" from a logical point of view.

For example, you could have a patch titled:
	[PATCH 01/05] staging: android: ion: remove unneeded returns

that just removed the unneeded return statemnents for all of the ion
files.

Then 4 other patches that do 4 other "logical" things, telling me what
order to apply them in.

Can you please fix up all of your recent submissions and resend in that
format?

> Signed-off-by: Sorin Facaoaru <work@sorin.cc> 

You have trailing whitespace here :(

thanks,

greg k-h
