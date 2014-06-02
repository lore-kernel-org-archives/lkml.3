Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaFBIBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:01:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21847 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaFBIBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:01:07 -0400
Date: Mon, 2 Jun 2014 11:00:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6 RESEND V2] staging: dgap: unwind on error in
 dgap_found_board()
Message-ID: <20140602080022.GT17724@mwanda>
References: <20140602051447.GA30379@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602051447.GA30379@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:14:47PM +0900, Daeseok Youn wrote:
> Adds a label for "kfree(brd)". And also remove
> a state value as BOARD_FAILED in brd when dgap_do_remap() is failed.
> Because "brd" will free after failure.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> RESEND: this patch is included into newly series of patches.
> V2: add "Reviewed-by" line in change log.

Don't worry about this stuff, Greg's scripts pick it up, or if they
don't, I don't care.

regards,
dan carpenter

