Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3LJFyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:54:08 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58007 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab3LJFyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:54:05 -0500
X-Sasl-enc: n2KHReRwaoVMuuEH+KNBw082icj/g8GoQfcBnk8rQNr3 1386654844
Date: Mon, 9 Dec 2013 21:55:05 -0800
From: Greg KH <greg@kroah.com>
To: Vishal Annapurve <vannapurve@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-storage: scsiglue: Changing the command result
Message-ID: <20131210055505.GA21002@kroah.com>
References: <113ACA888B71994BB56E5CF3704953486D664FCD42@BGMAIL02.nvidia.com>
 <20131209015905.GA5965@kroah.com>
 <52A590E7.9010603@nvidia.com>
 <20131209112315.GE6562@kroah.com>
 <52A6A56F.4040005@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A6A56F.4040005@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:53:59AM +0530, Vishal Annapurve wrote:
> Hi Greg,
> 
> Does this look fine? I will send over other patches
> once you confirm.

I'm not going to confirm a broken format...

Please go read the file I pointed you at as to how to properly do
this.

greg k-h
