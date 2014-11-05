Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaKERPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:15:10 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36463 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaKERPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:15:02 -0500
Date: Wed, 5 Nov 2014 18:11:50 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v10 3/3] gpio: add support for the Diolan DLN-2 USB GPIO
 driver
Message-ID: <20141105171150.GB21212@localhost>
References: <1415207101-16461-1-git-send-email-octavian.purdila@intel.com>
 <1415207101-16461-4-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415207101-16461-4-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 07:05:01PM +0200, Octavian Purdila wrote:
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
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Johan Hovold <johan@kernel.org>
