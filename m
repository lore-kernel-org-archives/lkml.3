Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496Ab3AQKIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:08:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759482Ab3AQKIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:08:09 -0500
Date: Thu, 17 Jan 2013 11:08:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support Jess/Saitek Color Rumble Pad
In-Reply-To: <1358272668-5124-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
Message-ID: <alpine.LNX.2.00.1301171108000.14768@pobox.suse.cz>
References: <alpine.LNX.2.00.1301031042530.27348@pobox.suse.cz> <1358272668-5124-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Michael Karcher wrote:

> 
> Add support for another gamepad to the hid-pl driver.
> The "color rumble pad P580" marketed using the "Saitek" brand in
> Germany, and using a USB Vendor ID attributed to "Jess" seems to be
> electronically identical to the 4-field variant of the "Green Asia"
> gamepad.
> 
> The pad has been tested to support rumble strengths up to 255, not
> just 127.
> 
> Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
