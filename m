Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3G3NMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:12:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21347 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3G3NMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:12:48 -0400
Date: Tue, 30 Jul 2013 16:12:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ozwpan: High resolution timers
Message-ID: <20130730131230.GC5002@mwanda>
References: <1375187510-28042-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375187510-28042-1-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 01:31:50PM +0100, Rupesh Gujare wrote:
> Current implementation assumes HZ = 1000 for calculating
> all internal timer intervals, which creates problem on
> platforms where HZ != 1000.
> 
> As well we need resolution of less than 10 mSec for heartbeat
> calculation, this creates problem on some platforms where HZ is
> configured as HZ = 100, or around, which restricts us to timer interval
> of 10 mSec. This is particularly found on embedded devices.
> 
> This patch moves on to use high resolution timers to calculate
> all timer intervals as it allows us to have very small resolution
> of timer interval, removing dependency on HZ.
>

I am new to this driver.  So we batch all the transfers together and
send/recieve them in oz_hcd_heartbeat() every 10msec?  It's a
polling interface?

Sorry, if I am completely mis-reading what this driver is doing.

In other words, could you explain what oz_hcd_heartbeat() does.

regards,
dan carpenter

