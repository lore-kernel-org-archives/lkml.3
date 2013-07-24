Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3GXWwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:52:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab3GXWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:52:09 -0400
Date: Wed, 24 Jul 2013 15:52:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] Remove static sizing of usb_device_id arrays
Message-ID: <20130724225208.GA3140@kroah.com>
References: <20130621235603.GA1603@kroah.com>
 <1371927359-13977-1-git-send-email-iko@iko.pp.se>
 <1371927359-13977-2-git-send-email-iko@iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371927359-13977-2-git-send-email-iko@iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 08:55:59PM +0200, Anders Hammarquist wrote:
> 
> Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
> ---
>  drivers/usb/serial/ti_usb_3410_5052.c |   29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)

This patch, and your previous one, are no longer needed, right?

thanks,

greg k-h
