Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab3LII2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:28:25 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48421 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932263Ab3LII2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:28:19 -0500
X-Sasl-enc: nQ0Rp9EQIGhbrtt53Zc/OpZiDIkzUkXASLugdJKvh/NP 1386577697
Date: Sun, 8 Dec 2013 17:59:05 -0800
From: Greg KH <greg@kroah.com>
To: Vishal Annapurve <vannapurve@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-storage: scsiglue: Changing the command result
Message-ID: <20131209015905.GA5965@kroah.com>
References: <113ACA888B71994BB56E5CF3704953486D664FCD42@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113ACA888B71994BB56E5CF3704953486D664FCD42@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 12:23:50PM +0530, Vishal Annapurve wrote:
> Hi,
> 
> Here are the updated patches:	

Can you please resend these in a format which I can apply them in
without having to hand-edit all three of them?

thanks,

greg k-h
