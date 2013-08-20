Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab3HTK2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:28:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab3HTK2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:28:04 -0400
Date: Tue, 20 Aug 2013 12:27:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: use correct type for ACPI _DSM parameter
In-Reply-To: <52122026.2010700@redhat.com>
Message-ID: <alpine.LNX.2.00.1308201225570.21654@pobox.suse.cz>
References: <1376910077-24433-1-git-send-email-mika.westerberg@linux.intel.com> <52122026.2010700@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013, Benjamin Tissoires wrote:

> > ACPI 5.0 specification requires the fourth parameter to the _DSM (Device
> > Specific Method) to be of type package instead of integer. Failing to do
> > that we get following warning on the console:
> > 
> >   ACPI Warning: \_SB_.PCI0.I2C1.TPL0._DSM: Argument #4 type mismatch - Found [Integer],
> >                 ACPI requires [Package] (20130517/nsarguments-95)
> > 
> > Fix this by passing an empty package to the _DSM method. The HID over I2C
> > specification doesn't require any specific values to be passed with this
> > parameter.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> 
> Looks simple and straightforward :)
> 
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
