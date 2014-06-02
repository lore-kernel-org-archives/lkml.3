Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaFBH6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:58:04 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20551 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaFBH6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:58:03 -0400
Date: Mon, 2 Jun 2014 10:57:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] staging: dgap: unwind on error in
 dgap_tty_register_ports()
Message-ID: <20140602075731.GS17724@mwanda>
References: <20140602050824.GA29914@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602050824.GA29914@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:08:24PM +0900, Daeseok Youn wrote:
> @@ -4177,12 +4183,46 @@ static int dgap_tty_register_ports(struct board_t *brd)
>  					brd->print_driver,
>  					brd->firstminor + i, NULL);

Btw, the "brd->firstminor + i" should just be "i".

TODO-list: 2014-06-02: dgap: get rid of brd->first minor because it is 0

regards,
dan carpenter

