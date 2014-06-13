Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaFMIeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:34:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42008 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaFMIeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:34:16 -0400
Date: Fri, 13 Jun 2014 11:33:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] staging: dgap: introduce dgap_release_remap()
Message-ID: <20140613083353.GE5015@mwanda>
References: <20140613074411.GA31639@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613074411.GA31639@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:44:11PM +0900, Daeseok Youn wrote:
> The dgap_found_board() did request some memory region and
> call ioremap, these should be released and unmaped
> when one of functions which are called after dgap_found_board()
> in dgap_init_one() is failed.
> 

Oh...  Here you clean up the rest that I mentioned in reviewing 8/9.

Fine fine.

regards,
dan carpenter

