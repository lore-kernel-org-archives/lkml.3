Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaDCK3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 06:29:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaDCK3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:29:47 -0400
Date: Thu, 3 Apr 2014 13:29:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Sampson <mike@sambodata.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Andreas Dilger <andreas.dilger@intel.com>,
        Kees Cook <keescook@chromium.org>, Peng Tao <bergwolf@gmail.com>,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] v3.14-7247-gcd6362b
 drivers/staging/lustre/lustre/libcfs/workitem.c Fix sparse warning.
Message-ID: <20140403102931.GK6991@mwanda>
References: <533d3246.82e6440a.77e1.ffffa143@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533d3246.82e6440a.77e1.ffffa143@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 08:43:28PM +1100, Mike Sampson wrote:
> Signed-off-by: Mike Sampson <mike@sambodata.com>
> 
> This fixes a sparse warning:
> warning: symbol 'cfs_wi_data' was not declared. Should it be static?
> 

Patch is ok.  Signed off should go at the end instead of at the start of
the commit message.  The subject should be:

[PATCH] Staging: lustre: mark a variable static in workitem.c

Espcially notice how I removed the "v3.14-7247-gcd6362b" and chose a
better prefix.  Btw, for these kinds of changes, then you should be
working against -next.

regards,
dan carpenter

