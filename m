Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3LQVB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:01:57 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:49568 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031Ab3LQVBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:01:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQIAIS7sFJ5LHyk/2dsb2JhbABZgwqDPLBthVCBIBd0giUBAQEEOhwjEAgDDgYECSUPBSUDIROIA8luFxaOfAeDI4ETBJgVikyHSYFtgVIo
Date: Wed, 18 Dec 2013 08:01:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Rich Johnston <rjohnston@sgi.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk, bpm@sgi.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v4 4/10] xfsprog: xfsio: Add support
 FALLOC_FL_COLLAPSE_RANGE for fallocate
Message-ID: <20131217210137.GF31386@dastard>
References: <1386511890-3794-1-git-send-email-linkinjeon@gmail.com>
 <52B08446.3080102@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B08446.3080102@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:05:10AM -0600, Rich Johnston wrote:
> This patch stands alone and has been committed.
> 
> Thanks
> --Rich
> 
> commit ca692f162d36c871c9c1b6169136b2c70503f2d8
> Author: Namjae Jeon <namjae.jeon@samsung.com>
> Date:   Sun Dec 8 14:11:30 2013 +0000
> 
>     xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

<sigh>

Rich, we've been here before:

19e73c9 Revert "[RESEND, 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE"

Please go back and read the discussion that lead to that revert.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
