Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbbARWWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 17:22:46 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbARWWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 17:22:42 -0500
Date: Sun, 18 Jan 2015 14:22:32 -0800
From: Darren Hart <dvhart@infradead.org>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: Jonathan Woithe <jwoithe@just42.net>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fujitsu-laptop: use FB_BLANK_* constants
Message-ID: <20150118222232.GA64157@vmdeb7>
References: <0150118191421.GJ56582@vmdeb7>
 <1421609326-3610-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421609326-3610-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 08:28:46PM +0100, Michael Karcher wrote:
> Replace the magic numbers in fujitsu-laptop.c by the appropriate FB_BLANK
> constants, as indicated by the comment for backlight_properties.power in
> include/linux/backlight.h.
> 
> Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

Thanks Michael, queued for 3.20.

-- 
Darren Hart
Intel Open Source Technology Center
