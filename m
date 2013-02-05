Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3BEIaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:30:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43190 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3BEIay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:30:54 -0500
Date: Tue, 5 Feb 2013 11:30:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roger Tseng <rogerable@realtek.com>
Cc: "cjb@laptop.org" <cjb@laptop.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wei_wang <wei_wang@realsil.com.cn>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/3] MMC: rtsx: remove driving adjustment
Message-ID: <20130205083037.GI4937@mwanda>
References: <1359963959-2305-1-git-send-email-rogerable@realtek.com>
 <1359963959-2305-2-git-send-email-rogerable@realtek.com>
 <20130204084737.GG4937@mwanda>
 <511073C5.9040300@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511073C5.9040300@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 10:51:49AM +0800, Roger Tseng wrote:
> Hi Dan,
> 
> Correct. I will prevent this kind of breaking in the future.
> 

Cool.  Or if we applied 2/3 first and then 1/3 there would be no
breakage?  Anyway, it's a bit late to combine them at this point.

> However, after our analysis the breaking of patch 1/3 and 2/3 should
> not fail old devices. And since Samuel has applied 2/3 and 3/3, it
> might be better for Chris to apply patch 1/3 and let all this things
> appear in kernel v3.9.
> 
> Hi Chris,
> 
> Would you please apply patch 1/3 for kernel v3.9. Thanks.
> 

Sounds good.

regards,
dan carpenter

