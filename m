Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935347Ab3DHQuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:50:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50669 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934484Ab3DHQuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:50:52 -0400
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 12:50:52 EDT
X-Sasl-enc: vxyj+7R6YAHjOma8Ualxl/gPJRi5SC0dGWX140TgfoTj 1365439330
Date: Mon, 8 Apr 2013 09:42:09 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH V5 0/6] USB: EHCI multiplatform for 3.10
Message-ID: <20130408164209.GA13694@kroah.com>
References: <1364919844-1726-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364919844-1726-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 06:23:58PM +0200, Arnd Bergmann wrote:
> Hi Greg,
> 
> Here are the EHCI patches that I think are good for inclusion in 3.10,
> I hope you are willing to include them after the debacle over these
> patches in 3.9.
> 
> The patches are all logically independent but sorted by priority,
> so decide for yourself how many you want to take, starting at the
> first one. The first six patches all have an Ack from Alan Stern
> and from the respective ARM platform maintainers.

I don't see an ACK for the 6th patch from Alan, any reason for that?

I've applied the first 5 for now, if you want the 6th one applied,
please resend.

thanks,

greg k-h
