Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaLHPhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:37:08 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:45346 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbaLHPhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:37:04 -0500
Date: Mon, 8 Dec 2014 16:37:01 +0100
From: Johan Hovold <johan@kernel.org>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, gregkh@linuxfoundation.org,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, Rajaram Regupathy <rera@cypress.com>
Subject: Re: [PATCH v4 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Message-ID: <20141208153701.GD14346@localhost>
References: <1417241944-17799-1-git-send-email-muth@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417241944-17799-1-git-send-email-muth@cypress.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 11:49:04AM +0530, Muthu Mani wrote:
> Adds support for USB-I2C/GPIO interfaces of Cypress Semiconductor
> CYUSBS234 USB-Serial Bridge controller.
> 
> Details about the device can be found at:
> http://www.cypress.com/?rID=84126
> 
> Signed-off-by: Muthu Mani <muth@cypress.com>
> Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> ---

This patch as well as the other two patches in the series is white-space
damaged. Please always make sure to run your patches through
checkpatch.pl before submission (and/or fix your mailer).

Also use git-send-email when submitting your series so that the
individual patches get threaded properly.

And always increase (or add a "resend" prefix) when resending. I got two
v4 series in my inbox. No idea what's the difference, if any.

Thanks,
Johan
