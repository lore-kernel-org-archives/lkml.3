Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaBFIqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:46:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbaBFIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:46:40 -0500
Date: Thu, 6 Feb 2014 09:46:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-sony Report actual brightness value when reading
 LED
In-Reply-To: <1391628858-2916-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1402060946260.24838@pobox.suse.cz>
References: <1391628858-2916-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Simon Wood wrote:

> The Dualshock4 controller contains a RGB LED, which is enabled via
> the '/sys/class/leds' interface. At present the driver only returns
> whether each of the RGB LEDs is lit (ie not off), but no indication
> of it's brightness.
> 
> This patch fixes the reading of the current brightnes so that it
> returns the value (rather than just off=0, on=LED_FULL).
> 
> Tested on the DS4 and SixAxis (for compatibility).
> 
> Signed-off-by: Simon Wood <simon@mungewell.org>

Applied, thanks Simon.

-- 
Jiri Kosina
SUSE Labs
