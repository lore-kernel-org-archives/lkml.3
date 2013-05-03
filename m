Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762395Ab3ECCnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:43:25 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41028 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3ECCnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:43:22 -0400
Date: Thu, 2 May 2013 19:33:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hayes Wang <hayeswang@realtek.com>
Cc: oliver@neukum.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Subject: Re: [PATCH v3 net-next] net/usb: new driver for RTL8152
Message-ID: <20130503023328.GB26712@kroah.com>
References: <1366965948-1805-1-git-send-email-hayeswang@realtek.com>
 <1367546485-1619-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367546485-1619-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:01:25AM +0800, Hayes Wang wrote:
> Add new driver for supporting Realtek RTL8152 Based USB 2.0 Ethernet Adapters
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>

You removed the wording I had questions about last time, does that mean
the previous wording was not correct, or that you no longer are
publicising the fact that this driver reads on some patents that you
own?

You also failed to answer my previous questions, why?

greg k-h
