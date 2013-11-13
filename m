Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab3KMOwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:52:40 -0500
Received: from fieldses.org ([174.143.236.118]:42510 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab3KMOwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:52:38 -0500
Date: Wed, 13 Nov 2013 09:52:36 -0500
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git
Message-ID: <20131113145236.GF28033@fieldses.org>
References: <20131111163034.GY13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111163034.GY13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:30:34PM +0000, Al Viro wrote:
> All kinds of stuff this time around; some more notable parts:
> 	* RCU'd vfsmounts handling
> 	* new primitives for coredump handling
> 	* files_lock is gone
> 	* Bruce's delegations handling series
> 	* exportfs fixes

Thanks.  The one thing I have left for you right now is jlayton's fix
for a lease/open race--is that still on your queue someplace?

It's at

	git://linux-nfs.org/~bfields/linux.git for-viro

if you need it.

(Nothing urgent, the race has been there forever, just want to make sure
it doesn't fall through the cracks.)

--b.
