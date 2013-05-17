Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3EQIaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:30:12 -0400
Received: from sauhun.de ([89.238.76.85]:59415 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab3EQIaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:30:10 -0400
Date: Fri, 17 May 2013 10:31:42 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: always clear interrupts before
 enabling them
Message-ID: <20130517083139.GC17056@katana>
References: <1368442471-7582-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368442471-7582-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 01:54:30PM +0300, Mika Westerberg wrote:
> If the I2C bus is put to a low power state by an ACPI method it might pull
> the SDA line low (as its power is removed). Once the bus is put to full
> power state again, the SDA line is pulled back to high. This transition
> looks like a STOP condition from the controller point-of-view which sets
> STOP detected bit in its status register causing the driver to fail
> subsequent transfers.
> 
> Fix this by always clearing all interrupts before we start a transfer.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied to for-current, thanks! Added stable, too.

