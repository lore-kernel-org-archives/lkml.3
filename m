Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaHKK5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:57:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48846 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaHKK5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:57:03 -0400
Date: Mon, 11 Aug 2014 13:56:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] staging: dgap: remove useless variable
Message-ID: <20140811105640.GN4856@mwanda>
References: <20140809053644.GA14630@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809053644.GA14630@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 02:36:44PM +0900, Daeseok Youn wrote:
> dgap_major_serial_registered and dgap_major_transparent_print_registered
> could be checked whether a board is initialized.
> But it doesn't need to check that variables becasue dgap module
> isn't calling the dgap_cleanup_tty() without initializing
> for a board completely.

I don't understand.  What about the call to dgap_cleanup_module() in
dgap_init_module()?

regards,
dan carpenter

