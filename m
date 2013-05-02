Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3EBRcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:32:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58405 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab3EBRcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:32:18 -0400
Date: Thu, 02 May 2013 13:32:15 -0400 (EDT)
Message-Id: <20130502.133215.2146231670932106380.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: hayeswang@realtek.com, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com
Subject: Re: [PATCH v2 net-next] net/usb: new driver for RTL8152
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130502141239.GC24348@kroah.com>
References: <1366965948-1805-1-git-send-email-hayeswang@realtek.com>
	<1367524087-29512-1-git-send-email-hayeswang@realtek.com>
	<20130502141239.GC24348@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 10:32:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 2 May 2013 07:12:39 -0700

> On Fri, May 03, 2013 at 03:48:07AM +0800, Hayes Wang wrote:
>> +#define PATENTS		"This product is covered by one or more of the " \
>> +			"following patents:\n" \
>> +			"\t\tUS6,570,884, US6,115,776, and US6,327,625.\n"
> 
> Interesting, you are aware of the issues involved with patents and GPLv2
> code, right?  Do you have a pointer to the GPLv2 patent release that is
> now required, or does your company now release all of the needed rights
> for these patents to be able to be used by everyone?

There is no way I'm applying a patch that adds notices like this to the
kernel log.
