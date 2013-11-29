Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3K2Ux7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:53:59 -0500
Received: from imap.thunk.org ([74.207.234.97]:34869 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab3K2Ux5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:53:57 -0500
Date: Fri, 29 Nov 2013 15:53:52 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] random: fix comment on "account"
Message-ID: <20131129205352.GE3778@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org
References: <cover.1384329436.git.price@mit.edu>
 <20131113080814.GS16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113080814.GS16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:08:14AM -0500, Greg Price wrote:
> This comment didn't quite keep up as extract_entropy() was split into
> four functions.  Put each bit by the function it describes.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Greg Price <price@mit.edu>

Thanks, applied.

							- Ted
