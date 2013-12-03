Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3LCHxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:53:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3LCHxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:53:51 -0500
Date: Tue, 3 Dec 2013 08:53:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Olivier Gay <ogay@logitech.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Mathieu Meisser <mmeisser@logitech.com>
Subject: Re: [PATCH] HID: logitech-dj: add HIDRAW dependency in Kconfig
In-Reply-To: <1386026244-21553-1-git-send-email-ogay@logitech.com>
Message-ID: <alpine.LNX.2.00.1312030852410.24931@pobox.suse.cz>
References: <1386026244-21553-1-git-send-email-ogay@logitech.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Olivier Gay wrote:

> hid-logitech-dj.c driver needs hidraw to work correctly. Without
> hidraw, hid-logitech-dj.c fails during probe() and Logitech
> Unifying devices HID reports aren't recognized.
> 
> Signed-off-by: Olivier Gay <ogay@logitech.com>
> Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
> Signed-off-by: Mathieu Meisser <mmeisser@logitech.com>
> ---
> 
> Hi everyone,
> 
> this adds a HIDRAW dependency in Kconfig for hid-logitech-dj.c
> driver. The driver uses hidraw and needs it to work correctly.
> 
> Without hidraw if a Logitech Unifying device is plugged, the driver
> fails during probe() and Logitech Unifying devices HID reports aren't
> recognized. This has been the cause of some confusion. Some Linux and
> Android distributions had HID_LOGITECH_DJ enabled without HIDRAW and
> the Unifying mice and keyboards would simply not work (no cursor

Hi Oliver,

I don't have my receiver with me at the moment, so can't really verify -- 
how exactly does it fail during probe()?

It's clear that without hidraw it's not possible to change the pairing 
from userspace, but I fail to see why probing the receiver should be 
affected?

Thanks,

-- 
Jiri Kosina
SUSE Labs
