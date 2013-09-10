Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3IJUvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:51:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20021 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3IJUu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:50:59 -0400
Date: Tue, 10 Sep 2013 23:47:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navinp@cdac.in>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: usbip: stub_main: correctly handle return
 value
Message-ID: <20130910204759.GA6329@mwanda>
References: <1378790047-3530-1-git-send-email-navinp@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378790047-3530-1-git-send-email-navinp@cdac.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:44:07AM +0530, navin patidar wrote:
> ret == 0 means success, anything else is failure.
> 

Hopefully, it's only returning negative error codes.  Otherwise it needs
a different fix.

There isn't an official kernel style on if "if (ret < 0)" is better than
"if (ret)".  Some subsystems have a preference but most don't care.
It's up to the maintainer to choose.

Your patch is fine, but the changelog is misleading.  It should just say
"I prefer the other style" instead of "This code is wrong and has buggy
error handling".

regards,
dan carpenter

