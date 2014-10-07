Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaJGQ7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:59:20 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58132 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbaJGQ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:59:15 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 7 Oct 2014 18:56:22 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 4/4] gpio: add support for the Diolan DLN-2 USB GPIO
 driver
Message-ID: <20141007165622.GH5362@localhost>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
 <1411661254-5204-5-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411661254-5204-5-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 07:07:34PM +0300, Octavian Purdila wrote:
> From: Daniel Baluta <daniel.baluta@intel.com>
> 
> This patch adds GPIO and IRQ support for the Diolan DLN-2 GPIO module.
> 
> Information about the USB protocol interface can be found in the
> Programmer's Reference Manual [1], see section 2.9 for the GPIO
> module commands and responses.
> 
> [1] https://www.diolan.com/downloads/dln-api-manual.pdf
> 
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---

Looks good. I'll provide my reviewed-by tag to the final submission.

Thanks,
Johan
