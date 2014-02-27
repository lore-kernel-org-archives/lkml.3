Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaB0SQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:16:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbaB0SQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:16:18 -0500
Message-ID: <530F80ED.1040509@infradead.org>
Date: Thu, 27 Feb 2014 10:16:13 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] Reorder drivers/video directory
References: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
In-Reply-To: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 03:54 AM, Tomi Valkeinen wrote:
> Hi,
> 
> This is a re-send of the series, with RFC removed from the subject, and a bunch
> of acks added.
> 
> I'm cc'ing more people, to make sure this doesn't come as a surprise, and to
> make sure this is not a bad idea, doomed to fail horribly.

What does this patch apply to?  I can't get it to apply cleanly to
-rc4 or Linus's current git tree.

I like what I see so far.

Thanks.

> So this series creates a new directory, drivers/video/fbdev/, to which all
> fbdev related files are moved. Also, a new directory, drivers/video/fbdev/core/
> is created, to which the core fbdev framework files are moved. This makes the
> drivers/video hierarchy much more clear.
> 
> Presuming no one has objections to this as such, I wonder what's the least
> painful way to merge this? Normally, like any other fbdev change? As a separate
> pull request, maybe at -rc2 time frame, based on -rc1? Something else?


-- 
~Randy
