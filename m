Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab3BZBus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:50:48 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44014 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3BZBur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:50:47 -0500
Date: Mon, 25 Feb 2013 17:50:43 -0800
From: "'Tejun Heo'" <tj@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
Message-ID: <20130226015043.GJ2679@htj.dyndns.org>
References: <009001ce13c3$9504bff0$bf0e3fd0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009001ce13c3$9504bff0$bf0e3fd0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:49:57AM +0900, Jingoo Han wrote:
> These functios allows the driver core to automatically clean up
> any allocation made by rtc drivers. Thus, it simplifies the error
> paths.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
