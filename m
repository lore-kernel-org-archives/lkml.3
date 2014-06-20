Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965895AbaFTJ0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:26:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29012 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934242AbaFTJ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:26:48 -0400
Date: Fri, 20 Jun 2014 12:26:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] staging: dgap: make dgap_found_board() return a brd
 pointer
Message-ID: <20140620092647.GY5015@mwanda>
References: <20140620092150.GA23842@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620092150.GA23842@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 06:21:50PM +0900, Daeseok Youn wrote:
> Make dgap_found_board() return a brd pointer and that brd pointer
> assign to dgap_board[] in the end of the dgap_init_one().
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Looks nice, thanks.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

