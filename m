Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaGKNU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:20:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22349 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaGKNU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:20:56 -0400
Date: Fri, 11 Jul 2014 16:20:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH 9/9] staging: dgap: removes redundant null check and
 change paramter for dgap_tty_digisetcustombaud()
Message-ID: <20140711132020.GZ25880@mwanda>
References: <20140711102434.GA22355@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711102434.GA22355@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.  You should be CC'ing Mark as well.  He's in
MAINTAINERS now.

I wish the two of you would CC each other and review each other's work.

Daeseok, add yourself to the MAINTAINERS file for this driver as well so
everyone CC's you on their dgap patches.  You're doing good work.

regards,
dan carpenter

