Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937535Ab3DIKRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:17:50 -0400
Received: from sauhun.de ([89.238.76.85]:38103 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935573Ab3DIKRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:17:49 -0400
Date: Tue, 9 Apr 2013 12:17:44 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH] i2c: remove CONFIG_HOTPLUG ifdefs
Message-ID: <20130409101744.GJ3624@the-dreams.de>
References: <1365471999-2396-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365471999-2396-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:46:39AM +0800, Yijing Wang wrote:
> CONFIG_HOTPLUG is going away as an option, cleanup CONFIG_HOTPLUG
> ifdefs in i2c files.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Applied to for-next, thanks!

