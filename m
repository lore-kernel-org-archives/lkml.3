Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3ARB1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:27:22 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:44366 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3ARB1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:27:20 -0500
Date: Thu, 17 Jan 2013 17:27:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [GIT PULL v3] Fixes/cleanup for vt8500 serial
Message-ID: <20130118012715.GA29023@kroah.com>
References: <1358363143-7154-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358363143-7154-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 08:05:39AM +1300, Tony Prisk wrote:
> Hi Greg,
> 
> This should be the final pull request for this series, unless there are
> other review comments. Changelog included.
> 
> v2:
> Restore the setting of vt8500_port->uart.uartclk which was dropped in v1.
> Corrected the return-on-fail of devm_request_and_ioremap to -EADDRNOTAVAIL.
> 
> v3:
> Corrected the commit message for patch 3
> 
> 
> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:
> 
>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
> 
> are available in the git repository at:
> 
>   git://server.prisktech.co.nz/git/linuxwmt.git tags/vt8500/serial-fixes

I don't take git pull requests for tiny stuff like this, sorry, only
patches through email.

But 2 of these patches had checkpatch issues, so I didn't take patches 3
and 4, please redo them.

thanks,

greg k-h
