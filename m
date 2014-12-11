Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbaLKWLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:11:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933771AbaLKWLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:11:21 -0500
Date: Thu, 11 Dec 2014 23:11:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Wu <peter@lekensteyn.nl>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] HID: logitech-hidpp: fixes for error conditions
In-Reply-To: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
Message-ID: <alpine.LNX.2.00.1412112310360.6679@pobox.suse.cz>
References: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Peter Wu wrote:

> Hi Jiri,
> 
> Here are four patches intended for the 3.19 stream and are based on
> jikos/hid (for-next, v3.18-rc4-144-gd9372ee).
> 
> * The first is actually from Benjamin Tissoires, but modified to remove
>   a now unneeded goto.
> * The second one depends on the first (it could work without, but there
>   will be a context mismatch).
> * The third one can be applied independently of the others and is needed
>   to avoid a possible buffer overread.
> * The fourth and final patch fixes an unbalanced hid_device_io_start().
> 
> Tested by booting with three paired USB devices (QEMU + USB
> passthrough), two of them are powered off and one M525 is active. evbug
> registers mouse events.
> 

Good stuff, thanks!

Applied.

-- 
Jiri Kosina
SUSE Labs
