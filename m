Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbaGOGri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:47:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16385 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaGOGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:47:35 -0400
Date: Tue, 15 Jul 2014 09:47:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH 6/8] staging: dgap: remove unneeded dgap_err()
Message-ID: <20140715064716.GR25880@mwanda>
References: <20140715030223.GA14406@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715030223.GA14406@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:02:23PM +0900, Daeseok Youn wrote:
> The dgap_err() is printing a message with pr_err(),
> so all those are replaced.
> 

Take a look at how pr_fmt works.

#define pr_fmt(fmt) "dgap: " fmt

Then you can remove the "dgap: " from the beginning of each line.

Also all the "out of memory" messages can be removed because the kernel
prints its own message for that.

regards,
dan carpenter

