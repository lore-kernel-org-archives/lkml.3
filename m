Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaEEPtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:49:19 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50007 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaEEPtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:49:17 -0400
Date: Mon, 5 May 2014 08:49:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/86] 3.10.39-stable review
Message-ID: <20140505154908.GA25199@roeck-us.net>
References: <20140504154140.444932005@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 11:40:35AM -0400, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.39 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue May  6 15:41:13 UTC 2014.
> Anything received after that time might be too late.
> 
Hi Greg,

did you get my reply with the build failure ?

Here it is again, in case it got lost:

drivers/usb/musb/musb_core.c: In function 'musb_stage0_irq':
drivers/usb/musb/musb_core.c:673:26: error: 'struct musb' has no member named 'hcd'

This is seen in 9 of my builds, including x86_64:allmodconfig and
x86_64:allyesconfig.

Guenter
