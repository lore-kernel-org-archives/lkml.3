Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3GOI1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:27:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab3GOI1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:27:35 -0400
Date: Mon, 15 Jul 2013 10:27:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Honza Brazdil <jbrazdil@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: kye: Add report fixup for Genius Gx Imperator
 Keyboard
In-Reply-To: <1373875938-10165-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1307151027260.29788@pobox.suse.cz>
References: <1373875938-10165-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Benjamin Tissoires wrote:

> Genius Gx Imperator Keyboard presents the same problem in its report
> descriptors than Genius Gila Gaming Mouse.
> Use the same fixup for both.
> 
> Fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=928561
> 
> Reported-and-tested-by: Honza Brazdil <jbrazdil@redhat.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> with the proper blacklist in hid-core this time.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
