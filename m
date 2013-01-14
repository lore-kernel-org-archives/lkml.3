Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3ANMSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:18:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46030 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab3ANMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:18:29 -0500
Date: Mon, 14 Jan 2013 12:18:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, sameo@linux.intel.com, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/14] usb: phy: nop: Handle power supply regulator for
	the PHY
Message-ID: <20130114121816.GZ23505@n2100.arm.linux.org.uk>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com> <1357836694-30788-5-git-send-email-rogerq@ti.com> <20130111171726.GI23505@n2100.arm.linux.org.uk> <50F3D5E2.4000102@ti.com> <20130114112549.GY23505@n2100.arm.linux.org.uk> <50F3F12B.4080906@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F3F12B.4080906@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 01:51:07PM +0200, Roger Quadros wrote:
> On 01/14/2013 01:25 PM, Russell King - ARM Linux wrote:
> > Also consider... is dev_err() appropriate for an "error", for which you
> > print a message and continue as if nothing went wrong.  To me that sounds
> > more like a warning than an error, so maybe dev_warn() would be more
> > appropriate?
> > 
> I used dev_dbg(), because we don't treat not getting the power supply
> regulator as that serious.

This comment is about what you do when regulator_enable() and the like
returns non-zero.
