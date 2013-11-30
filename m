Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab3K3BEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 20:04:07 -0500
Received: from imap.thunk.org ([74.207.234.97]:34892 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab3K3BEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 20:04:04 -0500
Date: Fri, 29 Nov 2013 20:04:00 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6/9] random: simplify accounting logic
Message-ID: <20131130010400.GF3778@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <cover.1384329436.git.price@mit.edu>
 <20131113080821.GT16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113080821.GT16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:08:21AM -0500, Greg Price wrote:
> This logic is exactly equivalent to the old logic, but it should
> be easier to see what it's doing.
> 
> The equivalence depends on one fact from outside this function:
> when 'r->limit' is false, 'reserved' is zero.  (Well, two facts;
> the other is that 'reserved' is never negative.)

Applied, thanks.

					- Ted
