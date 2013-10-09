Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3JIXHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:07:33 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:51081 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab3JIXHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:07:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0IALLgVVJ5LFuj/2dsb2JhbABagiVig0q5LYU/gR4XdIIlAQEFOhwjEAgDDgcDCSUPBSUDIROIBbdtgUAWjy8HhCMDmAKKP4dDgWaBUig
Date: Thu, 10 Oct 2013 10:07:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RESEND 4/7] xfsprogs: xfsio: add support
 FALLOC_FL_COLLAPSE_RANGE for fallocate
Message-ID: <20131009230724.GP4446@dastard>
References: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 05:13:38AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
