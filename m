Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaDWIgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:36:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50679 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaDWIgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:36:12 -0400
Date: Wed, 23 Apr 2014 11:35:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, yongjun_wei@trendmicro.com.cn,
        rupert@rmuch.net
Subject: Re: [PATCH] staging: silicom: remove redundant pci_get_drvdata() call
Message-ID: <20140423083547.GT26890@mwanda>
References: <20140423081842.GA7498@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423081842.GA7498@devel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 05:18:42PM +0900, Daeseok Youn wrote:
> The pci_get_drvdata() and checking NULL for dev are
> called twice in while loop in is_bypass_dev().
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> This patch has an warning from checkpatch.pl.
> checkpatch.pl warning:
> WARNING: Too many leading tabs - consider code refactoring

No problem.  Those were there and worse before your patch.

If someone wanted to fix these then just reverse every if condition in
the function.

regards,
dan carpenter

