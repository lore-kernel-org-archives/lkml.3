Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaLQTp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:45:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43766 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQTpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:45:25 -0500
Date: Wed, 17 Dec 2014 22:45:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hariharan <rhariharan.cbe@gmail.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: lustre: lproc_osc.c: used seq_puts() and
 seq_putc() instead of seq_printf()
Message-ID: <20141217194521.GN4856@mwanda>
References: <1418844479.9555.2.camel@hari-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418844479.9555.2.camel@hari-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 12:57:59AM +0530, Hariharan wrote:
> >From 55d1ae4a440126e5befa9de4698a7aac57319885 Mon Sep 17 00:00:00 2001
> From: Hariharan Rangasamy <rhariharan.cbe@gmail.com>
> Date: Thu, 18 Dec 2014 00:04:24 +0530
> Subject: [PATCH 2/2] Staging: lustre: lproc_osc.c: used seq_puts() and
>  seq_putc() instead of seq_printf()
> 

Don't include this stuff in the patch, it messes up the git log.  Read
the first paragraph of Documentation/email-clients.txt for more
information.

regards,
dan carpenter


