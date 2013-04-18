Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967276Ab3DRKuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:50:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33739 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967094Ab3DRKuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:50:19 -0400
Date: Thu, 18 Apr 2013 11:50:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: gregkh@linuxfoundation.org, tony@atomide.com, khilman@linaro.org,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sylvain Munaut <tnt@246tNt.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [RFT/PATCH 2/6] driver: serial: mpc52xx_uart: Remove
	"uart_console" defintion
Message-ID: <20130418105003.GB14500@n2100.arm.linux.org.uk>
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com> <1366198467-6757-3-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366198467-6757-3-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 05:04:23PM +0530, Sourav Poddar wrote:
> Since "uart_console" definition is now moved to serial core
> haeder file . Serial drivers need not define them.

This needs to be part of patch 1.  Having it separate may provoke compiler
warnings.
