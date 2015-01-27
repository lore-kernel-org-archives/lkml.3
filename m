Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbbA0H0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:26:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28117 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbA0H0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:26:49 -0500
Date: Tue, 27 Jan 2015 10:26:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>,
        "'tranmanphong@gmail.com'" <tranmanphong@gmail.com>,
        "'fabio.estevam@freescale.com'" <fabio.estevam@freescale.com>,
        "'prime.zeng@huawei.com'" <prime.zeng@huawei.com>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Gao, Neil" <Neil.Gao@sonymobile.com>
Subject: Re: [RFC] ion:change ion_cma_allocate return error value
Message-ID: <20150127072606.GR6456@mwanda>
References: <35FD53F367049845BC99AC72306C23D1044A02027DF9@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1044A02027DF9@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 02:04:21PM +0800, Wang, Yalin wrote:
> This patch change the error return value from -1 to -ENOMEM,
> so that userspace can get the correct errno, otherwise,
> -1 will be -EPERM, userspace will print permission deny for allocation
> failure.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>

Looks good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

