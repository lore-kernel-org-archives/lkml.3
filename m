Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaFMIAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:00:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29873 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaFMIAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:00:37 -0400
Date: Fri, 13 Jun 2014 11:00:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] staging: dgap: introduce dgap_tty_unregister()
Message-ID: <20140613080017.GC5015@mwanda>
References: <20140613074147.GA31615@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613074147.GA31615@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:41:47PM +0900, Daeseok Youn wrote:
> dgap_tty_unregister() will unregister serial_driver
> and print_driver, and also free related variables.
> 

Introducing a static function without a caller will cause a GCC warning
about unused functions.

Fold 5,7 and 8 together into one patch.  This is still "one thing per
patch" because they can't be done separately.

regards,
dan carpenter

