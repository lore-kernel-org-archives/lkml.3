Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab3EBONI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:13:08 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33047 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555Ab3EBONF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:13:05 -0400
Date: Thu, 2 May 2013 07:12:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hayes Wang <hayeswang@realtek.com>
Cc: oliver@neukum.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Subject: Re: [PATCH v2 net-next] net/usb: new driver for RTL8152
Message-ID: <20130502141239.GC24348@kroah.com>
References: <1366965948-1805-1-git-send-email-hayeswang@realtek.com>
 <1367524087-29512-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367524087-29512-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 03:48:07AM +0800, Hayes Wang wrote:
> +#define PATENTS		"This product is covered by one or more of the " \
> +			"following patents:\n" \
> +			"\t\tUS6,570,884, US6,115,776, and US6,327,625.\n"

Interesting, you are aware of the issues involved with patents and GPLv2
code, right?  Do you have a pointer to the GPLv2 patent release that is
now required, or does your company now release all of the needed rights
for these patents to be able to be used by everyone?

thanks,

greg k-h
