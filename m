Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaIDVgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:36:55 -0400
Received: from imap.thunk.org ([74.207.234.97]:38669 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbaIDVgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:36:53 -0400
Date: Thu, 4 Sep 2014 17:36:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v10 19/21] xip: Add xip_zero_page_range
Message-ID: <20140904213641.GB4364@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <willy@linux.intel.com>,
	Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
 <80c8efc903971eb3a338f262fbd3ef135db63eb0.1409110741.git.matthew.r.wilcox@intel.com>
 <20140903092116.GF20473@dastard>
 <20140904210802.GA27730@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904210802.GA27730@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 05:08:02PM -0400, Matthew Wilcox wrote:
> 
> ext4 does (or did?) have this bug (expectation?).  I then take advantage
> of the fact that we have to accommodate it, so there are now two places
> that have to accommodate it.  I forget what the path was that has that
> assumption, but xfstests used to display it.
> 
> I'm away this week (... bad timing), but I can certainly fix it elsewhere
> in ext4 next week.

Huh?  Can you say more about what it is or was doing?  And where?

I tried to look for it, and I'm not seeing it, but I'm not entirely
sure from your description whether I'm looking in the right place.

Cheers,

     	       		   	       	       - Ted
