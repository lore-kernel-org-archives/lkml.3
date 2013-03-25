Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab3CYVE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:04:56 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50350 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3CYVEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:04:55 -0400
Date: Mon, 25 Mar 2013 14:04:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 5/9 RESEND] staging: ste_rmi4: kill platform_data hack
Message-ID: <20130325210453.GA18214@kroah.com>
References: <1364245211-21422-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364245211-21422-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:00:11PM +0100, Linus Walleij wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There is only one instance of the platform data for synaptics_i2c_rmi4
> in the mainline kernel, so there is no point of pretending its
> variable here. The only member that has a dependency on the platform
> is actually the interrupt number, and there is a field in the
> i2c_client structure that gets initialized from the board info,
> so we can trivially move the board_into into the platform without
> knowledge of the platform_data structure.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Greg, seeking your ACK on this to take it through the ARM SoC
> tree.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
