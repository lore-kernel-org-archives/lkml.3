Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaCENbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:31:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbaCENbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:31:41 -0500
Date: Wed, 5 Mar 2014 14:31:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] HID: multitouch cleanups and support for fancy
 devices
In-Reply-To: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1403051430450.30402@pobox.suse.cz>
References: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, Benjamin Tissoires wrote:

> - the first patch is mainly a way for us to reduce the work load regarding hid-mt
>   when device makers ask for an inclusion in the kernel.
>   Also, I have been notified that a Quanta 3008 was not working, and it occurs
>   that this particular device has a special handling in hid-mt. Of course, the
>   hardware maker reused the same VID/PID, but changed the protocol.
>   So yes, I am in favour of killing all unneeded special cases.
> 
>   I checked all the devices I was able to test, and this leaves us a bunch of
>   devices which, I am sure, could be removed too (all the ones following
>   MT_CLS_NSMU should be in this case). So, if anyone else wants to join me in
>   this crusade, I'd be glad to receive patches.
> 
> - the second and third patch are the v2 of the series I sent back in December
>   2013 ([PATCH 0/3] Change in handling different input device in hid-multitouch).
>   Henrik made valuable comments, and I did not had the time to look at it and to
>   figure out how to address them. Now I got a different look at this work, and
>   I think I addressed the issues (no more function pointers, yeah!)

This is now queued for 3.15 -- so please send any followup patches / 
comments on top of for-3.15/multitouch.

Thanks,

-- 
Jiri Kosina
SUSE Labs
