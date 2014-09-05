Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbaIEJsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:48:08 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43754 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756600AbaIEJsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:48:02 -0400
Date: Fri, 5 Sep 2014 10:47:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anders Berg <anders.berg@avagotech.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH 1/2] gpio: Add driver for AXM55xx SSP chip selects
Message-ID: <20140905094747.GE30401@n2100.arm.linux.org.uk>
References: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com> <1409576021-24828-2-git-send-email-anders.berg@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409576021-24828-2-git-send-email-anders.berg@avagotech.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 02:53:40PM +0200, Anders Berg wrote:
> The AXM55xx device has a ARM PL022 SSP controller with an extension that
> enables the control of up to five chip select signals. This driver implements
> the logic to control these signals and exports them as GPIOs.
> 
> Signed-off-by: Anders Berg <anders.berg@avagotech.com>

So, what happens if the GPIO driver binds first, followed by the SSP
device?  Please test that scenario out before this patch gets merged.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
