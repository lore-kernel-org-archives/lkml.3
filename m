Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3EBWAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 18:00:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40945 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3EBWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 18:00:44 -0400
Date: Thu, 2 May 2013 15:00:31 -0700
From: Joel Becker <jlbec@evilplan.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH v3 06/18] ocfs2: use ->invalidatepage() length argument
Message-ID: <20130502220030.GC26770@localhost>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	ocfs2-devel@oss.oracle.com
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
 <1365498867-27782-7-git-send-email-lczerner@redhat.com>
 <20130423141604.GE31170@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423141604.GE31170@thunk.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Joel Becker <jlbec@evilplan.org>

On Tue, Apr 23, 2013 at 10:16:04AM -0400, Theodore Ts'o wrote:
> On Tue, Apr 09, 2013 at 11:14:15AM +0200, Lukas Czerner wrote:
> > ->invalidatepage() aop now accepts range to invalidate so we can make
> > use of it in ocfs2_invalidatepage().
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Cc: Joel Becker <jlbec@evilplan.org>
> 
> +Mark Fasheh, ocfs2-devel
> 
> To the ocfs2 development team,
> 
> Since half of this patch series modifies ext4 extensively, and changes
> to the other file systems are relatively small, I plan to carry the
> invalidatepage patch set in the ext4 tree for the next development
> cycle (i.e., not the upcoming merge window, but the next one).  To
> that end, it would be great if you take a look at this patch set and
> send us an Acked-by signoff.
> 
> Thanks!!
> 
> 						- Ted

-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

			http://www.jlbec.org/
			jlbec@evilplan.org
