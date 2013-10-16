Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761Ab3JPUYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:24:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761077Ab3JPUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:24:29 -0400
Date: Wed, 16 Oct 2013 13:24:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: davem@davemloft.net, bjorn@mork.no, dcbw@redhat.com,
        christian.schmiedl@gemalto.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antonella Pellizzari <anto.pellizzari83@gmail.com>
Subject: Re: [PATCH] net: qmi_wwan: Olivetti Olicard 200 support
Message-ID: <20131016202428.GA24399@kroah.com>
References: <1381842408-10800-1-git-send-email-mrkiko.rs@gmail.com>
 <1381842408-10800-2-git-send-email-mrkiko.rs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381842408-10800-2-git-send-email-mrkiko.rs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 03:06:48PM +0200, Enrico Mioso wrote:
> This is a QMI device, manufactured by TCT Mobile Phones.
> A companion patch blacklisting this device's QMI interface in the option.c
> driver has been sent.
> 
> Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
> Signed-off-by: Antonella Pellizzari <anto.pellizzari83@gmail.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
