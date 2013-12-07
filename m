Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3LGOtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 09:49:13 -0500
Received: from imap.thunk.org ([74.207.234.97]:37498 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab3LGOtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 09:49:07 -0500
Date: Sat, 7 Dec 2013 09:48:57 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 9/9] random: simplify accounting code
Message-ID: <20131207144857.GB21100@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <cover.1384329436.git.price@mit.edu>
 <20131113080841.GW16018@ringworld.MIT.EDU>
 <20131206011347.GD9010@thunk.org>
 <20131206182503.GK8043@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206182503.GK8043@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 01:25:04PM -0500, Greg Price wrote:
> 
> Sure, that'd be reasonable.  I didn't do that mainly because I wanted
> to preserve existing behavior wherever possible in these cleanups, to
> make them easy to read and review.

I'll make that change and apply this patch, thanks.

	    	      	   	      - Ted
