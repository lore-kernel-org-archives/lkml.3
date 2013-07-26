Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3GZU4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:56:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab3GZU4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:56:11 -0400
Date: Fri, 26 Jul 2013 13:56:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Feng-Hsin Chiang <john453@faraday-tech.com>
Cc: stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com, balbi@ti.com,
        florian@openwrt.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanlmm@gmail.com,
        ratbert.chuang@gmail.com, lichun_c@faraday-tech.com,
        john2437kimo@gmail.com, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH v3] usb: host: Faraday fotg210-hcd driver
Message-ID: <20130726205610.GA15573@kroah.com>
References: <1374832376-30567-1-git-send-email-john453@faraday-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374832376-30567-1-git-send-email-john453@faraday-tech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 09:52:56AM +0000, Feng-Hsin Chiang wrote:
> FOTG210 is an OTG controller which can be configured as an
> USB2.0 host. FOTG210 host is an ehci-like controller with
> some differences. First, register layout of FOTG210 is
> incompatible with EHCI. Furthermore, FOTG210 is lack of
> siTDs which means iTDs are used for both HS and FS ISO
> transfer.
> 
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
> ---
> v2: fix most of errors and warnings reported by checkpatch.pl
> v3: change maintainer

You didn't refresh this against the latest tree, and as such, it fails
to apply to the tree, which implies that you didn't test it against the
latest kernel version either :(

Please do this and resend it after testing.

thanks,

greg k-h
