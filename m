Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3BFK7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:59:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36510 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3BFK67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:58:59 -0500
Date: Wed, 6 Feb 2013 10:57:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gregkh@linuxfoundation.org, tony@atomide.com, eballetbo@gmail.com,
        javier@dowhile0.org, b-cousson@ti.com, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/5] ARM: OMAP2: MUSB: Specify omap4 has mailbox
Message-ID: <20130206105713.GF17852@n2100.arm.linux.org.uk>
References: <1360130294-5976-1-git-send-email-kishon@ti.com> <1360130294-5976-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360130294-5976-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 11:28:11AM +0530, Kishon Vijay Abraham I wrote:
> Added has_mailbox to the musb platform data to specify that omap uses
> an external mailbox (in control module) to communicate with the musb
> core during device connect and disconnect.

So, I've been through your five patches looking for any other users of
"has_mailbox" and I can find none.  You introduce this in this patch,
and you set it.  But I don't see anything that uses it.

Write only variables are not useful.
