Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbaHNN5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:57:04 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:64009 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaHNN5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:57:02 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Thu, 14 Aug 2014 09:56:58 -0400
To: Joe Perches <joe@perches.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Kinglong Mee <kinglongmee@gmail.com>
Subject: Re: [PATCH] locks: Remove unused conf argument from lm_grant
Message-ID: <20140814095658.1716c48e@tlielax.poochiereds.net>
In-Reply-To: <1408024360-5177-1-git-send-email-jlayton@primarydata.com>
References: <1408024360-5177-1-git-send-email-jlayton@primarydata.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014 09:52:40 -0400
Jeff Layton <jlayton@primarydata.com> wrote:

> From: Joe Perches <joe@perches.com>
> 
> This argument is always NULL so don't pass it around.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Jeff Layton <jlayton@primarydata.com>
> ---
>  fs/dlm/plock.c     |  8 ++++----
>  fs/lockd/svclock.c | 12 +++---------
>  include/linux/fs.h |  2 +-
>  3 files changed, 8 insertions(+), 14 deletions(-)
> 

Joe, if this looks OK with you, I'll plan to merge this for v3.18.

Kinglong, I've added this to my "locks-3.18" branch if you need
something to base your nfsd conflock patches on:

    git://git.samba.org/jlayton/linux.git

Thanks,
-- 
Jeff Layton <jlayton@primarydata.com>
