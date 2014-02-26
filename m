Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaBZJVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:21:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29017 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaBZJVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:21:32 -0500
Date: Wed, 26 Feb 2014 12:20:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, bergwolf@gmail.com,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: make functions as static
Message-ID: <20140226092050.GO26722@mwanda>
References: <3395735.omIA0Togio@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3395735.omIA0Togio@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:17:59PM +0900, Daeseok Youn wrote:
> 
> These functions are only referenced in this file scope
> so it can be marked static.
> And remove space between function name and open parenthesis.

If it's on the same line as a "static" change then it's fine, otherwise
it should go in a separate patch.

regards,
dan carpenter

