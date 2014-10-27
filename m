Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaJ0MxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:53:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49185 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJ0MxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:53:05 -0400
Date: Mon, 27 Oct 2014 15:52:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        devel@driverdev.osuosl.org, gunho.lee@lge.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] staging: ion: debugfs to shrink pool
Message-ID: <20141027125247.GB6890@mwanda>
References: <1414068740-9553-1-git-send-email-gioh.kim@lge.com>
 <1414068740-9553-3-git-send-email-gioh.kim@lge.com>
 <20141027114240.GC6879@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027114240.GC6879@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 02:42:40PM +0300, Dan Carpenter wrote:
> On Thu, Oct 23, 2014 at 09:52:20PM +0900, Gioh Kim wrote:
> > This patch creates debugfs files, /sys/kernel/debug/ion/heaps/system_shrink,
> > to shrink pool or get pool size.
> > Reading the file returns pool size and writing occurs to shrink pool.
> 
> The patch looks fine.  Of course, the original code was debugfs before
> it bitrotted and stopped compiling, but is there there a reason why we
> shouldn't move this to sysfs instead?  Just curious.
> 

I read the Laura's review comments and it turns out we don't want this
enabled by default and debugfs is fine.  Question answered.

regards,
dan carpenter

