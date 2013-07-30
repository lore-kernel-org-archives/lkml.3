Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3G3N5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:57:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3G3N5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:57:10 -0400
Date: Tue, 30 Jul 2013 06:58:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH v3 1/3] net/usb/r815x: replace USB buffer from stack to
 DMA-able
Message-ID: <20130730135828.GD27962@kroah.com>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
 <1375172936-4145-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375172936-4145-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 04:28:54PM +0800, Hayes Wang wrote:
> Allocate the transfer buffer in probe(), and use the buffer for
> usb control transfer.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r815x.c | 117 +++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 90 insertions(+), 27 deletions(-)

In the future, you do not need to send drivers/net/usb/ patches to me,
netdev and the linux-usb mailing lists should be sufficient.

thanks,

greg k-h
