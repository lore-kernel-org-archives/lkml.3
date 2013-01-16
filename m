Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3APG4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:56:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:36522 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab3APG4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:56:53 -0500
Date: Tue, 15 Jan 2013 22:57:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 4/4] serial: tty: Cleanup code using devm_ function
Message-ID: <20130116065747.GA20126@kroah.com>
References: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
 <1358225886-5686-5-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358225886-5686-5-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 05:58:06PM +1300, Tony Prisk wrote:
> Convert the last memory allocation (vt8500_port) to use devm_kzalloc
> and remove the fail path cleanup code from vt8500_serial_probe.
> 
> Reorder iomem mapping above clk_enable to simplify fail code. The
> clock is only enabled if all other resources are available.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

You've send a few different versions of this patch, with no indication
as to what changed, or what one I should take.  Care to send me the
correct one?

thanks,

greg k-h
