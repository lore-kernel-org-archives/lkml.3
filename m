Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3GEHTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 03:19:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44909 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3GEHTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 03:19:33 -0400
Date: Fri, 5 Jul 2013 10:19:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] rapidio: use after free in unregister function
Message-ID: <20130705071912.GY5714@mwanda>
References: <20130705060231.GA14443@elgon.mountain>
 <51D67066.9070105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D67066.9070105@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 05:06:14PM +1000, Ryan Mallon wrote:
> On 05/07/13 16:02, Dan Carpenter wrote:
> It looks like an mport_id can only be assigned to one scan entry (see
> rio_register_scan), so you can use list_for_each_entry and break; after
> the kfree(scan); instead.

Yeah.  You're right.  I'll resend.

regards,
dan carpenter

