Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaFDOWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:22:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaFDOWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:22:13 -0400
Date: Wed, 4 Jun 2014 07:22:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>
Subject: Re: [PATCH 1/2] serial: core: Don't drop DTR if system console
Message-ID: <20140604142208.GA1008@kroah.com>
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>
 <1401891371-4946-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401891371-4946-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:16:10AM -0400, Peter Hurley wrote:
> If a tty is opened on a serial console, don't drop DTR on
> last tty close, on tty hangup, or when resetting port hardware
> via TIOCSSERIAL and TIOCSERCONFIG ioctls.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/serial/serial_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Is this a regression, or something we have never done?

thanks,

greg k-h
