Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3KUJab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:30:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3KUJa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:30:28 -0500
Date: Thu, 21 Nov 2013 10:30:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Adam Kulagowski <fidor@fidor.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: kye: fix unresponsive keyboard
In-Reply-To: <1384958982-23099-2-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1311211030060.22082@pobox.suse.cz>
References: <1384958982-23099-1-git-send-email-benjamin.tissoires@redhat.com> <1384958982-23099-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013, Benjamin Tissoires wrote:

> The manticore keyboard requires that all usb EP are opened at least
> once to be fully functional. The third EP forwards to the user space
> some vendor specific information about the keyboard state, but are useless
> currently for the kernel.
> 
> Opening them and closing them makes the keyboard responsive again.
> 
> Reported-and-tested-by: Adam Kulagowski <fidor@fidor.org>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi Jiri,
> 
> well, this one was a long shot as I do not have the hardware to actually
> spot the exact call which enables the keyboard. Adam told me that just
> opening and closing once all the /dev/hidrawX attached to the keyboard makes
> the keyboard functional, so, here is the kernel version of this.
> Anyway, it just works, so I think we can take this one as well.

Man, this is ugly :)

What can we do anyway. Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
