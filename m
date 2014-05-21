Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaEURoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:44:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47791 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEURoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:44:23 -0400
Date: Wed, 21 May 2014 20:44:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Giedrius Rekasius <giedrius.rekasius@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove unused local variable "stored" from
 ext4_readdir(...)
Message-ID: <20140521174409.GD15585@mwanda>
References: <20140521153226.GD8826@vaio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521153226.GD8826@vaio>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 04:32:26PM +0100, Giedrius Rekasius wrote:
> From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
> 
> Remove local variable "stored" from ext4_readdir(...). This variable 
> gets initialized but is never used inside the function.
> 
> Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>

Looks good.

regards,
dan carpenter

