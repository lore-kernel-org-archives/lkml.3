Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab3BYM3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 07:29:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab3BYM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 07:29:47 -0500
Date: Mon, 25 Feb 2013 13:29:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] hid driver transport cleanup
In-Reply-To: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1302251328070.2128@pobox.suse.cz>
References: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013, Benjamin Tissoires wrote:

> Hi guys,
> 
> this is the v2 of the hid transport cleanup.
> 
> Changes since v1:
> - gathered reviewed/acked/etc..
> - changed commit messages of patches 4-6
> - add newcomer into account (thingm)
> - incorporated the i2c-hid driver change into the series
> 
> I still did not implemented the final usb cleanup for hid-multitouch as it may
> required few comments.

I have now taken the series. Thanks Benjamin, thanks Henrik.

-- 
Jiri Kosina
SUSE Labs
