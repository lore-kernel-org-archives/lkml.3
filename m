Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaEWJZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:25:13 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:53130 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEWJZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:25:10 -0400
Date: Fri, 23 May 2014 11:25:01 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 2/4] cris: Update comments for generic idle conversion
Message-ID: <20140523092501.GI9198@axis.com>
References: <1400835265-21956-1-git-send-email-geert+renesas@glider.be>
 <1400835265-21956-3-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400835265-21956-3-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 10:54:23AM +0200, Geert Uytterhoeven wrote:
> As of commit 8dc7c5ecd8d0f739728d844ee794c4fae169f9c2 ("cris: Use generic
> idle loop"), cris no longer provides cpu_idle().
> 
>   - On cris-v10, etrax_gpio_wake_up_check() is called from
>     default_idle() instead of cpu_idle(),
>   - On cris-v32, etrax_gpio_wake_up_check() is not called from
>     default_idle(), so remove this (copy-and-paste?) part.

Yes, the comment for ETRAX FS (mach-fs) is definitely copy-pasted.

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
