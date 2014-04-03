Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162447AbaDCHlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:41:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27606 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162293AbaDCHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:41:14 -0400
Date: Thu, 3 Apr 2014 10:41:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, silentquote@gmail.com
Subject: Re: [PATCH 2/2] driver: staging: wlan-ng: Removed unnecessary
 typedefs from hfa384x_usb.c
Message-ID: <20140403074101.GX6991@mwanda>
References: <1396484754-32500-1-git-send-email-shehabaldin.sherif@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396484754-32500-1-git-send-email-shehabaldin.sherif@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 02:25:54AM +0200, Sherif Shehab Aldin wrote:
> Removed unnecessary typedefs from hfa384x_usb.c
> 
> Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>

You've broken this patch set up in a wrong way.  It should have just
been one patch.  Don't introduce a warning and fix it later.  The two
changes are closely related so they fall under the one thing per patch
rule.

The subject for this patch is nonsense because it fixes a long line.  I
can see how you meant is as in you were fixing up the typedef patch that
context will be lost in the final git log.

regards,
dan carpenter

