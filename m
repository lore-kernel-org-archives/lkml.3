Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbaDXMd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:33:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:48007 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753280AbaDXMd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:33:26 -0400
Date: Thu, 24 Apr 2014 13:32:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH 03/13] video: clarify I2C dependencies
Message-ID: <20140424123235.GS26756@n2100.arm.linux.org.uk>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org> <1398342509-10243-4-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398342509-10243-4-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 01:28:19PM +0100, Peter Griffin wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> We can only use I2C support in frame buffer drivers if
> Either I2C is built-in, or both I2C and the driver itself
> are loadable modules.

Why?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
