Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaETUIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:08:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29690 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaETUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:08:43 -0400
Date: Tue, 20 May 2014 23:08:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Giedrius Rekasius <giedrius.rekasius@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove unused local variable "store" from
 ext4_readdir(...)
Message-ID: <20140520200827.GM15585@mwanda>
References: <20140520144113.GB13333@vaio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520144113.GB13333@vaio>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 03:41:13PM +0100, Giedrius Rekasius wrote:
> From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
> 
> Remove unused local variable "store" from ext4_readdir(...)
> 
> Local variable "stored" is initialized however never used inside the function.
> 
> Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>

You email client is corrupting the patch so it doesn't apply.

Read Documentation/email-clients.txt (linux-next version).

regards,
dan carpenter

