Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab3FYPVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:21:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45056 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752659Ab3FYPVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:21:44 -0400
Date: Tue, 25 Jun 2013 11:21:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: USB tree now closed for 3.11
In-Reply-To: <20130625150732.GA19676@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1306251119100.1340-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Greg KH wrote:

> Hi all,
> 
> With the release of the 3.10-rc7 kernel, I think it's time to close the
> USB tree for new features / cleanups for 3.11.  So I'm closing my
> tree, and will only be applying obvious bugfixes or regressions to it
> until 3.11-rc1 comes out.
> 
> You can keep sending me patches for the tree that don't fit the "bugfix"
> category, but note that I'll be storing them away to wait for 3.11-rc1
> comes out, which might be a few weeks, so please be patient.
> 
> The USB tree right now contains 382 patches, and the diffstat
> summary is:
> 	 410 files changed, 18183 insertions(+), 4956 deletions(-)

Instead of storing away new patches where people can't easily get at
them, you could create a temporary branch to hold them until 3.11-rc1
is released.  Would that involve a significant amount of extra work?

Alan Stern

