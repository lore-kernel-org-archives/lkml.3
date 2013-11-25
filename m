Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3KYWTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:19:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3KYWTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:19:00 -0500
Date: Mon, 25 Nov 2013 23:18:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jerome Blin <jerome.blin@intel.com>
Subject: Re: [PATCH] HID: i2c-hid: disable interrupt on suspend
In-Reply-To: <52936FC5.3060905@redhat.com>
Message-ID: <alpine.LNX.2.00.1311252318350.22082@pobox.suse.cz>
References: <1384342458-5551-1-git-send-email-mika.westerberg@linux.intel.com> <52936FC5.3060905@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013, Benjamin Tissoires wrote:

> > When an I2C HID device is powered of during system sleep, as a result of
> > removing its power resources (by the ACPI core) the interrupt line might go
> > low as well. This results inadvertent interrupt and wakes the system from
> > sleep immediately.
> > 
> > To prevent this we disable the device interrupt in the drivers suspend
> > method and enable it on resume. The device can still wake the system up if
> > it is wake capable (this also means that not all of its power will be
> > removed to keep the interrupt line high).
> > 
> > Reported-by: Jerome Blin <jerome.blin@intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> 
> Jiri, just FYI, I still do not have any final consumer ready i2c-hid
> hardware. So I can not test/debug anything related to the suspend-resume.
> 
> If Mika tested it properly (which I expect), you may consider pulling
> this one.

Understood, thanks guys.

Applied now.

-- 
Jiri Kosina
SUSE Labs
