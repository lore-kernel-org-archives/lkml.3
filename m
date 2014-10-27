Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaJ0Lm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:42:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39532 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaJ0Lm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:42:58 -0400
Date: Mon, 27 Oct 2014 14:42:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        devel@driverdev.osuosl.org, gunho.lee@lge.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] staging: ion: debugfs to shrink pool
Message-ID: <20141027114240.GC6879@mwanda>
References: <1414068740-9553-1-git-send-email-gioh.kim@lge.com>
 <1414068740-9553-3-git-send-email-gioh.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414068740-9553-3-git-send-email-gioh.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 09:52:20PM +0900, Gioh Kim wrote:
> This patch creates debugfs files, /sys/kernel/debug/ion/heaps/system_shrink,
> to shrink pool or get pool size.
> Reading the file returns pool size and writing occurs to shrink pool.

The patch looks fine.  Of course, the original code was debugfs before
it bitrotted and stopped compiling, but is there there a reason why we
shouldn't move this to sysfs instead?  Just curious.

regards,
dan carpenter

