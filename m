Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3ARB0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:26:14 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:55549 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3ARB0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:26:13 -0500
Date: Thu, 17 Jan 2013 17:26:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 4/4 v3] serial: vt8500: Cleanup code using devm_ function
Message-ID: <20130118012608.GA28984@kroah.com>
References: <1358363143-7154-1-git-send-email-linux@prisktech.co.nz>
 <1358363143-7154-5-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358363143-7154-5-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 08:05:43AM +1300, Tony Prisk wrote:
> Convert the last memory allocation (vt8500_port) to use devm_kzalloc
> and remove the fail path cleanup code from vt8500_serial_probe.
> 
> Reorder iomem mapping above clk_enable to simplify fail code. The
> clock is only enabled if all other resources are available.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>  drivers/tty/serial/vt8500_serial.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)

As I dropped patch 3, I can't take this one either.

greg k-h
