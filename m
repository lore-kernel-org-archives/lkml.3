Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaHMR6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:58:23 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58470 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaHMR6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:58:21 -0400
Date: Wed, 13 Aug 2014 10:58:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] watchdog: xilinx: Remove .owner field for driver
Message-ID: <20140813175816.GA16662@roeck-us.net>
References: <e8e4f914035bfd055525e224da9d3e62e70edb1b.1407930684.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8e4f914035bfd055525e224da9d3e62e70edb1b.1407930684.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 01:51:28PM +0200, Michal Simek wrote:
> There is no need to init .owner field.
> 
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
> 
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
