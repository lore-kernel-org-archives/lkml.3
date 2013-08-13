Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3HMXA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:00:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43154 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3HMXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:00:27 -0400
Date: Wed, 14 Aug 2013 02:00:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] staging: ozwpan: Separate success & failure case
 for oz_hcd_pd_arrived()
Message-ID: <20130813230009.GT5502@mwanda>
References: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
 <1376414966-23525-6-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376414966-23525-6-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 06:29:26PM +0100, Rupesh Gujare wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> This patch separates success & failure block along with fixing
> following issues:-
> 
> 1. The way oz_hcd_pd_arrived() looks now it's easy to think we free "ep" but
> actually we do this spaghetti thing of setting it to NULL on success.
> 
> 2. It is hard to read it because there are unlocks scattered throughout.
> 
> 3. Currently we set "ep" to NULL on the success path and then test it and or
> free it. In current code you have to scroll to the start of the function
> to read code.
> 
> Original patch was submitted by Dan here :-
> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2013-August/040113.html
> 
> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>

Since you gave me the author tag for this then I'll sign off on this
as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

