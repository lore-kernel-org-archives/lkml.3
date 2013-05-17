Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3EQV7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:59:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab3EQV7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:59:04 -0400
Date: Fri, 17 May 2013 14:59:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: bmheight@gmail.com
Cc: john.stultz@linaro.org, konkers@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: android: sync: use seq_puts()/seq_putc() to
 follow coding style
Message-ID: <20130517215903.GA2794@kroah.com>
References: <1368736202-10673-1-git-send-email-bmheight@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368736202-10673-1-git-send-email-bmheight@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:30:02AM -1000, bmheight@gmail.com wrote:
> From: Brandon Height <bmheight@gmail.com>
> 
> Utilized seq_puts() for strings without format specifiers.
> Utilized seq_putc() for seq_printf(s, "\n")
> 
> Signed-off-by: Brandon Height <bmheight@gmail.com>

Sorry, someone beat you to this same patch a few days ago, so I can't
apply it.

greg k-h
