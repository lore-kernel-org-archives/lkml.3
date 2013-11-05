Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3KELDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:03:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23267 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3KELDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:03:06 -0500
Date: Tue, 5 Nov 2013 14:02:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: jfrederich@gmail.com, dsd@laptop.org, jon.nettleton@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 2/2] staging/olpc_docn: reorder the lock sequence
 to avoid potential dead lock
Message-ID: <20131105110242.GQ26669@mwanda>
References: <5278C1DC.9000609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5278C1DC.9000609@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 06:01:00PM +0800, Gu Zheng wrote:
> The lock sequence of dcon_blank_fb(fb_info->lock ---> console_lock) is against
> with the one of console_callback(console_lock ---> fb_info->lock), it'll
> lead to a potential dead lock, so reorder the lock sequence of dcon_blank_fb
> to avoid the potential dead lock.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Relax, Greg isn't taking new patches for another three weeks because the
merge window is open.

Also what happened to [PATCH 1/2]?

regards,
dan carpenter

