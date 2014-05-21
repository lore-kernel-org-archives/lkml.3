Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaEUNvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:51:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33643 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaEUNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:51:45 -0400
Date: Wed, 21 May 2014 16:51:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Giedrius Rekasius <giedrius.rekasius@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove unused local variable "store" from
 ext4_readdir(...)
Message-ID: <20140521135130.GK17724@mwanda>
References: <20140520144113.GB13333@vaio>
 <20140520200827.GM15585@mwanda>
 <20140521134158.GB4719@vaio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521134158.GB4719@vaio>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better, but still not quite right.  Read paragraph 2 from
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Documentation/email-clients.txt

Try applying this patch with `git am`, then review the log.  It has our
entire conversation preserved for ever in the git history.

https://www.google.com/search?q=how+to+send+a+v2+patch

regards,
dan carpenter

