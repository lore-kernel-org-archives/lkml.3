Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab3LGTUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 14:20:49 -0500
Received: from imap.thunk.org ([74.207.234.97]:37535 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036Ab3LGTUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 14:20:46 -0500
Date: Sat, 7 Dec 2013 14:20:40 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] random: clarify bits/bytes in wakeup thresholds
Message-ID: <20131207192040.GA13776@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org
References: <cover.1386382885.git.price@mit.edu>
 <20131207022803.GZ16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131207022803.GZ16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 09:28:03PM -0500, Greg Price wrote:
> These are a recurring cause of confusion, so rename them to
> hopefully be clearer.
> 
> Signed-off-by: Greg Price <price@mit.edu>

Thanks, applied with some merge fix ups to get the patch to apply.

		     	  	    	- Ted
