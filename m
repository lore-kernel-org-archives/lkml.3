Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaLPLto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:49:44 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:57560 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaLPLtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:49:42 -0500
Date: Tue, 16 Dec 2014 12:49:40 +0100
From: Johan Hovold <johan@kernel.org>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: handle -ENODEV quietly in
 generic_submit_read_urb
Message-ID: <20141216114940.GJ6778@localhost>
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
 <1418340594-30469-3-git-send-email-jmmahler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418340594-30469-3-git-send-email-jmmahler@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 03:29:54PM -0800, Jeremiah Mahler wrote:
> If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
> unplugged, an -ENODEV (19) error will be produced after it gives up
> trying to resubmit a read.
> 
>   usb_serial_generic_submit_read_urb - usb_submit_urb failed: -19
> 
> Add -ENODEV as one of the permanent errors along with -EPERM that
> usb_serial_generic_submit_read_urb() handles quietly without an error.
> 
> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>

I'll apply this one once v3.19-rc1 is out.

Thanks,
Johan
