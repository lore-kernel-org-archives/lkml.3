Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3H1HNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:13:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32840 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3H1HNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:13:18 -0400
Date: Wed, 28 Aug 2013 10:13:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] xHCI: Fixing xhci_readl definition and function call
Message-ID: <20130828071304.GO6329@mwanda>
References: <1377482937-7486-1-git-send-email-kumargauravgupta3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377482937-7486-1-git-send-email-kumargauravgupta3@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 07:38:57AM +0530, Kumar Gaurav wrote:
> This patch redefine function xhci_readl.xhci_readl function doesn't use xhci_hcd argument.
> Hence there is no need of keeping it in the function arguments. 
> 
> Redefining this function breaks other functions which calls this function.
> This phatch also correct those calls in xhci driver. 
> 
> Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
> ---

Could you put a list of changes since v2 here?:

v3:  blah blah changelog mostly.

Also this doesn't apply for me against linux-next.

regards,
dan carpenter

