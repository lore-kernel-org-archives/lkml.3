Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaEUPQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:16:37 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57705 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbaEUPQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:16:35 -0400
Date: Wed, 21 May 2014 16:16:30 +0100
From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove unused local variable "store" from
 ext4_readdir(...)
Message-ID: <20140521151630.GC8826@vaio>
References: <20140520144113.GB13333@vaio>
 <20140520200827.GM15585@mwanda>
 <20140521134158.GB4719@vaio>
 <20140521135130.GK17724@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521135130.GK17724@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 04:51:30PM +0300, Dan Carpenter wrote:
> Better, but still not quite right.  Read paragraph 2 from
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Documentation/email-clients.txt
> 
> Try applying this patch with `git am`, then review the log.  It has our
> entire conversation preserved for ever in the git history.
> 
> https://www.google.com/search?q=how+to+send+a+v2+patch

Thank you for explanation Dan, I think I got it this time. 

I'm going to resubmit this patch in a new thread because there is a typo 
in the subject.

Regards,
Giedrius
