Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab3DBPHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:07:40 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58302 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab3DBPHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:07:39 -0400
Date: Tue, 2 Apr 2013 11:06:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130402150651.GB31577@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
	Jiri Slaby <jslaby@suse.cz>
References: <20130402142717.GH32241@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402142717.GH32241@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 03:27:17PM +0100, Mel Gorman wrote:
> I'm testing a page-reclaim-related series on my laptop that is partially
> aimed at fixing long stalls when doing metadata-intensive operations on
> low memory such as a git checkout. I've been running 3.9-rc2 with the
> series applied but found that the interactive performance was awful even
> when there was plenty of free memory.

Can you try 3.9-rc4 or later and see if the problem still persists?
There were a number of ext4 issues especially around low memory
performance which weren't resolved until -rc4.

Thanks,

						- Ted
