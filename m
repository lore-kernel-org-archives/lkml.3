Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3K2T7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:59:13 -0500
Received: from imap.thunk.org ([74.207.234.97]:34856 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab3K2T7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:59:11 -0500
Date: Fri, 29 Nov 2013 14:59:07 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] random: fix comment on proc_do_uuid
Message-ID: <20131129195907.GB3778@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org
References: <cover.1384329436.git.price@mit.edu>
 <20131113080726.GP16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113080726.GP16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:07:26AM -0500, Greg Price wrote:
> There's only one function here now, as uuid_strategy is long gone.
> Also make the bit about "If accesses via ..." clearer.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Greg Price <price@mit.edu>

Thanks, applied.

					- Ted
