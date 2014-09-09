Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaIIHPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:15:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43100 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaIIHPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:15:05 -0400
Date: Tue, 9 Sep 2014 10:14:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nitin Kuppelur <nitinkuppelur@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: octeon-hcd: removed unwanted return from void
 functions
Message-ID: <20140909071428.GO6600@mwanda>
References: <1410196395-4595-1-git-send-email-nitinkuppelur@gmail.com>
 <20140908185923.GA10550@drone.musicnaut.iki.fi>
 <540DFEDA.2060202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DFEDA.2060202@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 09:09:14PM +0200, Nitin Kuppelur wrote:
> Hi Aaro,
> 
> Thanks for review. I will correct the commit log length and resend the patch.
> 
> About the __cvmx_usb_perform_complete():
> Here return statement has associated label. Due to which it will add
> compilation warning. So I am not handling this.

Just remove the label as well.  Do-nothing labels are a plague.

regards,
dan carpenter

