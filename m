Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3EaPPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:15:06 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53757 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3EaPPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:15:01 -0400
Date: Fri, 31 May 2013 11:14:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, hughd@google.com
Subject: Re: [PATCH v4 20/20] ext4: Allow punch hole with bigalloc enabled
Message-ID: <20130531151454.GB19561@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	hughd@google.com
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
 <1368549454-8930-21-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368549454-8930-21-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 06:37:34PM +0200, Lukas Czerner wrote:
> In commits 5f95d21fb6f2aaa52830e5b7fb405f6c71d3ab85 and
> 30bc2ec9598a1b156ad75217f2e7d4560efdeeab we've reworked punch_hole
> implementation and there is noting holding us back from using punch hole
> on file system with bigalloc feature enabled.
> 
> This has been tested with fsx and xfstests.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

This patch is causing a test failure with bigalloc enabled with the
xfstests shared/298.

Since it's at the end of the invalidate page range tests, I'm going to
drop this patch for now.  Could you take a look at this?

Thanks!!

					- Ted
