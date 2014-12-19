Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaLSKEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 05:04:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaLSKD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 05:03:59 -0500
Date: Fri, 19 Dec 2014 11:03:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: detect HID++ 2.0 errors too
In-Reply-To: <20141217153039.GB16047@mail.corp.redhat.com>
Message-ID: <alpine.LNX.2.00.1412191102570.1680@pobox.suse.cz>
References: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl> <1418691016-30681-2-git-send-email-peter@lekensteyn.nl> <20141217153039.GB16047@mail.corp.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Benjamin Tissoires wrote:

> > Devices speaking HID++ 2.0 report a different error code (0xff). Detect
> > these errors too to avoid 5 second delays when the device reports an
> > error. Caught by... well, a bug in the QEMU emulation of this receiver.
> > 
> > Renamed fap to rap for HID++ 1.0 errors because it is more logical,
> > it has no functional difference.
> > 
> > Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> > ---
> 
> Jiri, it looks like this one fall off from your radar.
> 
> It's not a problem per-se, I'd like to have some feedbacks from Logitech
> first, but still, there is a bug and Peter fixed it :)

It's actually still on my radar, but that was exactly the reason I have it 
on hold, because my understanding was that you are waiting for Logitech to 
review it.

Nestor ... ?

-- 
Jiri Kosina
SUSE Labs
