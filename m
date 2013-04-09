Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936762Ab3DIBxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:53:36 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42047 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab3DIBxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:53:35 -0400
Date: Mon, 8 Apr 2013 18:53:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        jiang.liu@huawei.com, Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH] i2c: remove CONFIG_HOTPLUG ifdefs
Message-ID: <20130409015331.GA27472@kroah.com>
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
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Bill Pemberton <wfp5p@virginia.edu>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
