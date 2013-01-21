Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3AUQCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:02:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51205 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab3AUQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:02:00 -0500
Date: Mon, 21 Jan 2013 16:01:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roger Quadros <rogerq@ti.com>
Cc: sameo@linux.intel.com, balbi@ti.com, tony@atomide.com, kishon@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 05/22] mfd: omap-usb-tll: Clean up clock handling
Message-ID: <20130121160133.GP23505@n2100.arm.linux.org.uk>
References: <20130118145906.GE23505@n2100.arm.linux.org.uk> <1358766286-5425-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358766286-5425-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:04:46PM +0200, Roger Quadros wrote:
> Every channel has a functional clock that is similarly named.
> It makes sense to use a for loop to manage these clocks as OMAPs
> can come with up to 3 channels.
> 
> Dynamically allocate and get channel clocks depending on the
> number of clocks avaiable on the platform.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Much better from the clk API usage, thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
