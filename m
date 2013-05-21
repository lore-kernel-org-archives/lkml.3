Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3EUJGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:06:25 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60940 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3EUJGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:06:23 -0400
Date: Tue, 21 May 2013 11:06:16 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, libo.chen@huawei.com,
        gregkh@linuxfoundation.org, samuel@sortiz.org,
        stern@rowland.harvard.edu, khc@pm.waw.pl, akpm@linux-foundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com,
        alexander.shishkin@linux.intel.com, brudley@broadcom.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
Message-ID: <20130521110616.21eee053@skate>
In-Reply-To: <519B2993.4090409@cn.fujitsu.com>
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com>
	<20130520.232619.964940909999914694.davem@davemloft.net>
	<20130521084108.1a585f32@skate>
	<519B2993.4090409@cn.fujitsu.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gu Zheng,

On Tue, 21 May 2013 16:00:19 +0800, Gu Zheng wrote:

> > Or, maybe make the existing module_platform_driver() macro do this?
> 
> But not all the modules use module_platform_driver() macro to replace the module init/exit.

Then maybe it's a good opportunity to convert those ones to use
module_platform_driver() ?

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
