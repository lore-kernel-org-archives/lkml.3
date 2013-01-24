Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab3AXH3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:29:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34039 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3AXH24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:28:56 -0500
Date: Thu, 24 Jan 2013 08:28:46 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>, dirk.brandewie@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] i2c-designware: add Intel Lynxpoint support
Message-ID: <20130124072846.GO8364@nekote.pengutronix.de>
References: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 12:31:03PM +0200, Mika Westerberg wrote:
> Hi all,
> 
> This series adds support for the Intel Lynxpoint Low Power Subsystem I2C
> controllers. They are compatible with the DesignWare I2C controller.
> 
> Patches [1/4] and [2/4] are fixes that are necessary to get the driver
> working on Lynxpoint.
> 
> Patch [3/4] brings minimal runtime PM support for the designware platform
> driver. This is useful if the PM subsystem/domain implements runtime PM,
> like in case of ACPI.
> 
> Patch [4/4] finally implements ACPI enumeration support for the designware
> platform driver and adds Lynxpoint ACPI IDs.

I can't tell much about ACPI usage, but rest looks good to me. Applied
to next.
