Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab3LGOuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 09:50:24 -0500
Received: from imap.thunk.org ([74.207.234.97]:37501 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab3LGOuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 09:50:23 -0500
Date: Sat, 7 Dec 2013 09:50:20 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.13 PATCH 1/2] random: entropy_bytes is actually bits
Message-ID: <20131207145020.GC21100@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org
References: <cover.1386382885.git.price@mit.edu>
 <20131207022751.GY16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131207022751.GY16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 09:27:52PM -0500, Greg Price wrote:
> The variable 'entropy_bytes' is set from an expression that actually
> counts bits.  Fortunately it's also only compared to values that also
> count bits.  Rename it accordingly.
> 
> Signed-off-by: Greg Price <price@mit.edu>

Thanks, applied.

					- Ted
