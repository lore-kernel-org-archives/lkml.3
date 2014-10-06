Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaJFNf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:35:58 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36164 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaJFNf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:35:56 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 6 Oct 2014 15:33:02 +0200
From: Johan Hovold <johan@kernel.org>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajaram Regupathy <rera@cypress.com>
Subject: Re: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Message-ID: <20141006133302.GA2306@localhost>
References: <1412599949-3818-1-git-send-email-muth@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412599949-3818-1-git-send-email-muth@cypress.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 06:22:29PM +0530, Muthu Mani wrote:
> Adds support for USB-I2C/GPIO interfaces of Cypress Semiconductor
> CYUSBS234 USB-Serial Bridge controller.
> 
> Details about the device can be found at:
> http://www.cypress.com/?rID=84126
> 
> Signed-off-by: Muthu Mani <muth@cypress.com>
> Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> ---

Please resend this series and include a revision changelog per patch
(you can keep it under the cut-off line).

Also, make sure not to drop thread participants from CC when resending.

Thanks,
Johan
