Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3AVGoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:44:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42744 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3AVGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:44:04 -0500
Date: Tue, 22 Jan 2013 09:43:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/iio: Use correct argument for sizeof
Message-ID: <20130122064351.GV4584@mwanda>
References: <1358802842-27614-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358802842-27614-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 10:14:02PM +0100, Peter Huewe wrote:
> found with coccicheck
> sizeof when applied to a pointer typed expression gives the size of
> the pointer
> 

The original code is correct, in this case.  We're storing an array
of pointers and the last element in the array is a NULL.

> The semantic patch that makes this output is available
> in scripts/coccinelle/misc/noderef.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/

Can you remove those two boiler plate lines?  We all have google.

regards,
dan carpenter

