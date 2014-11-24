Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaKYGzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:55:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaKYGzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:55:17 -0500
Date: Mon, 24 Nov 2014 00:18:23 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] toshiba_acpi: Fix regression caused by backlight
 extra check code
Message-ID: <20141124081823.GB97532@vmdeb7>
References: <1416882576-3203-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416882576-3203-1-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 07:29:36PM -0700, Azael Avalos wrote:
> Bug 86521 uncovered that some TOS6208 devices also return
> non zero values on a write call to the backlight method,
> thus getting caught and bailed out by the extra check code.
> 
> This patch changes the set_lcd_brightness function to its
> "original" state by just adapting it to the new function
> format.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
> Changes since v1:
> - Simply revert the commit to its original state by just
>   adapting the code to the new function format
> 
> Darren,
> 
> This patch simply reverts the commit so the bug can be closed,
> I'll send a few patches later which will include the change
> needed to block the backlight on TOS1900 devices for review.

Queued.

Thanks Azael,

-- 
Darren Hart
Intel Open Source Technology Center
