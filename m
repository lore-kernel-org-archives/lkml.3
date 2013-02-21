Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3BUAGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:06:22 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:46137 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3BUAGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:06:20 -0500
Date: Wed, 20 Feb 2013 16:06:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: maxin.john@gmail.com
Cc: mina86@mina86.com, matt.fleming@intel.com, matthias.fend@wolfvision.net,
        balbi@ti.com, linux-usb@vger.kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH] tools: usb: ffs-test: Fix build failure
Message-ID: <20130221000649.GB14395@kroah.com>
References: <1361404671-11713-1-git-send-email-maxin.john@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361404671-11713-1-git-send-email-maxin.john@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 01:57:51AM +0200, maxin.john@gmail.com wrote:
> From: "Maxin B. John" <maxin.john@enea.com>
> 
> Fixes this build failure:
> gcc -Wall -Wextra -g -lpthread -I../include -o testusb testusb.c
> gcc -Wall -Wextra -g -lpthread -I../include -o ffs-test ffs-test.c
> In file included from ffs-test.c:41:0:
> ../../include/linux/usb/functionfs.h:4:39: fatal error:
> uapi/linux/usb/functionfs.h: No such file or directory
> compilation terminated.
> make: *** [ffs-test] Error 1

This is a build failure where, 3.8, or linux-next, or somewhere else?

thanks,

greg k-h
