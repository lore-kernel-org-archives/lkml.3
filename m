Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaEGBbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 21:31:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaEGBbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 21:31:51 -0400
Date: Tue, 6 May 2014 18:31:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: John Church <j.church@ymail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        georgiana.chelu93@gmail.com, waydi1@gmail.com
Subject: Re: [PATCH] Staging: android: fix coding style issue for Eudyptula
 Challenge in timed_gpio.c
Message-ID: <20140507013146.GA4245@kroah.com>
References: <536973DF.8010503@ymail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536973DF.8010503@ymail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 12:44:31AM +0100, John Church wrote:
> 

> Signed-off-by: John Church <j.church@ymail.com>


What coding style issue?

You need to be specific in your body of your email, and put a blank line
after the signed-off-by and before the patch, otherwise the tools can
complain.

And drop the Eudyptula challenge line in subject:, it's not needed at
all.

Can you redo this and resend?

thanks,

greg k-h
