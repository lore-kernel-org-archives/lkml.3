Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3DWOOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:14:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43869 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab3DWOOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:14:52 -0400
Date: Tue, 23 Apr 2013 10:14:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH v3 05/18] xfs: use ->invalidatepage() length argument
Message-ID: <20130423141442.GD31170@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
 <1365498867-27782-6-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365498867-27782-6-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:14:14AM +0200, Lukas Czerner wrote:
> ->invalidatepage() aop now accepts range to invalidate so we can make
> use of it in xfs_vm_invalidatepage()
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com

To the xfs team,

Since half of this patch series modifies ext4 extensively, and changes
to the other file systems are relatively small, I plan to carry the
invalidatepage patch set in the ext4 tree for the next development
cycle (i.e., not the upcoming merge window, but the next one).  To
that end, it would be great if you take a look at this patch set and
send us an Acked-by signoff.

Thanks!!

						- Ted
