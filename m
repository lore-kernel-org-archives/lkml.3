Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab3FQFUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:20:40 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52076 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3FQFUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:20:38 -0400
Date: Mon, 17 Jun 2013 00:20:35 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] pinctrl: update GPIO range doc
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
References: <1371377909-5921-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1371377909-5921-1-git-send-email-linus.walleij@stericsson.com>
	(from linus.walleij@stericsson.com on Sun Jun 16 05:18:29 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1371446435.2776.122@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 05:18:29 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This updates the GPIO range documentation with the API changes
> for sparse/random/arbitrary pin-to-GPIO mappings.

Acked-by: Rob Landley <rob@landley.net>

Why isn't this part of the pinctrl series you posted right afterwards?  
(It should go in through that maintainer...)

>  For all functionalities dealing with pin biasing, pin muxing etc,  
> the pin
> -controller subsystem will subtract the range's .base offset from the  
> passed
> -in gpio number, and add the ranges's .pin_base offset to retrive a  
> pin number.
> -After that, the subsystem passes it on to the pin control driver, so  
> the driver
> +controller subsystem will look up the corresponding pin number from  
> the passed
> +in gpio number, and use the ranges internals to retrive a pin  
> number. After

Range's perhaps?

Rob