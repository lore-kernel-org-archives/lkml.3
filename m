Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3EUGl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:41:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60584 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3EUGlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:41:25 -0400
Date: Tue, 21 May 2013 08:41:08 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: David Miller <davem@davemloft.net>
Cc: libo.chen@huawei.com, gregkh@linuxfoundation.org, samuel@sortiz.org,
        stern@rowland.harvard.edu, khc@pm.waw.pl, akpm@linux-foundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com,
        alexander.shishkin@linux.intel.com, brudley@broadcom.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
Message-ID: <20130521084108.1a585f32@skate>
In-Reply-To: <20130520.232619.964940909999914694.davem@davemloft.net>
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com>
	<20130520.232619.964940909999914694.davem@davemloft.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David Miller,

On Mon, 20 May 2013 23:26:19 -0700 (PDT), David Miller wrote:
> From: Libo Chen <libo.chen@huawei.com>
> Date: Tue, 21 May 2013 10:42:00 +0800
> 
> > I find a lot of mistakes using struct platform_driver without owner.
> > So I pick up some of them including usb and net modules
> 
> Instead of doing it this way, which is obviously error prone and
> easy to forget, make platform_driver_register() be a macro which
> sets the module owner field then calls the real
> __platform_driver_register().

Or, maybe make the existing module_platform_driver() macro do this?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
