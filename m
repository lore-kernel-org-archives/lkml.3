Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab3DBPPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:15:24 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58313 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab3DBPPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:15:22 -0400
Date: Tue, 2 Apr 2013 11:14:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130402151436.GC31577@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
	Jiri Slaby <jslaby@suse.cz>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402150651.GB31577@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 11:06:51AM -0400, Theodore Ts'o wrote:
> 
> Can you try 3.9-rc4 or later and see if the problem still persists?
> There were a number of ext4 issues especially around low memory
> performance which weren't resolved until -rc4.

Actually, sorry, I took a closer look and I'm not as sure going to
-rc4 is going to help (although we did have some ext4 patches to fix a
number of bugs that flowed in as late as -rc4).

Can you send us the patch that you used to get record these long stall
times?  And I assume you're using a laptop drive?  5400RPM or 7200RPM?

	      	     	    	    	   - Ted
