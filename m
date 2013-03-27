Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3C0NLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:11:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab3C0NLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:11:39 -0400
Date: Wed, 27 Mar 2013 14:11:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3.9+] HID: multitouch: fix touchpad buttons
In-Reply-To: <1363974837-8958-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1303271410510.23442@pobox.suse.cz>
References: <1363974837-8958-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013, Benjamin Tissoires wrote:

> Commit "HID: multitouch: use the callback "report" instead..." breaks the
> buttons of touchpads following the HID multitouch specification.
> The buttons were emmitted through hid-input, but as now the events
> are generated only in hid-multitouch, the buttons are not emmitted anymore.
> 
> The input_event() call is far much simpler than the hid-input one as
> many of the different tests do not apply to multitouch touchpads.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi guys,
> 
> really sorry for that. I forgot that I had in one of my drawer of my desk one
> prototype of a touchpad following the multitouch specification, but with
> two physical buttons. And of course, I did not put it in my database, meaning
> that the support has been broken in the patches already in 3.9.
> 
> I don't think it's a big deal (to my knowledge, no retail product uses this
> feature), but it's still a regression in 3.9.

I am queuing this for 3.9 still, thanks.

Benjamin, just please double-check that the patch is ok as-is in my 
for-3.9/upstream-fixes branch, as I had to hand-apply it due to 
context-related conflicts.

-- 
Jiri Kosina
SUSE Labs
