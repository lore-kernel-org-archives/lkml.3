Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaLVNZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:25:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaLVNZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:25:02 -0500
Date: Mon, 22 Dec 2014 14:24:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Duggan <aduggan@synaptics.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH 1/3] HID: rmi: Support non rmi devices by passing events
 to hid-input
In-Reply-To: <1419029143-20484-1-git-send-email-aduggan@synaptics.com>
Message-ID: <alpine.LNX.2.00.1412221424160.1680@pobox.suse.cz>
References: <1419029143-20484-1-git-send-email-aduggan@synaptics.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Andrew Duggan wrote:

> Allowing hid-rmi to bind to non rmi devices allows us to support composite USB
> devices which contain several HID devices one of which is a HID touchpad.
> Since all of the devices have the same VID and PID we can add the device
> to the hid_have_special_driver list and have hid-rmi handle all of the devices.
> Then hid-rmi's probe can look for the rmi specific HID report IDs and decide if
> it should handle the device as a rmi device or simply report that the events
> needs additional processing.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---
> This patch series is my second attempt at getting the hid-rmi driver working on
> the Razer Blade 14 based on Benjamin's comments. I decided to break it up into
> three separate patches. This one allows hid-rmi to bind to all of the devices.
> Instead of adding a quirk I just look at the report IDs to see if it should
> do rmi or not.

I have now applied 1/3, and waiting for v2 once you sort out with Benjamin 
the comments he had.

Thanks,

-- 
Jiri Kosina
SUSE Labs
