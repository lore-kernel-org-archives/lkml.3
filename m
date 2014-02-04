Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaBDPZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:25:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaBDPZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:25:49 -0500
Date: Tue, 4 Feb 2014 16:27:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] usb: musb: host: fixes for 3.14-rc
Message-ID: <20140204152725.GB8556@kroah.com>
References: <1391520349-26192-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391520349-26192-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 03:25:47PM +0200, Roger Quadros wrote:
> Hi Greg,
> 
> Patch 1 fixes SuperSpeed hub enumeration on beaglebone.
> Patch 2 fixes remote-wakeup resume on beaglebone.
> 
> Felipe has Acked the 1st patch but still needs to Ack the 2nd one.
> 
> Patches are based on 3.14-rc1

Why wouldn't these come into my tree from Felipe like normal?  Why
should I take them?

confused,

greg k-h
