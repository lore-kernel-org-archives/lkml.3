Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3FYRBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:01:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FYRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:01:21 -0400
Date: Tue, 25 Jun 2013 10:02:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, shigekatsu.tateno@atmel.com
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
Message-ID: <20130625170205.GA21328@kroah.com>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 05:30:02PM +0100, Rupesh Gujare wrote:
> convert all debug messages from printk to dev_dbg() & add kernel config to
> enable/disable these messages during compilation.

No, just use the built-in dynamic debug code in the kernel, no need to
provide any new macros or functions or most importantly, no new Kconfig
options.

greg k-h
