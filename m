Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3I3BHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:07:39 -0400
Received: from mail-gg0-f170.google.com ([209.85.161.170]:41261 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3I3BHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:07:36 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Sep 2013 21:07:36 EDT
Message-ID: <5248CD05.7000700@gmail.com>
Date: Sun, 29 Sep 2013 20:59:49 -0400
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: George Spelvin <linux@horizon.com>, akpm@linux-foundation.org,
        eldad@fogrefinery.com, jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Check real user/group id for %pK
References: <20130929234146.31004.qmail@science.horizon.com> <5248C8A1.3090302@gmail.com> <5248CC2D.1080000@gmail.com>
In-Reply-To: <5248CC2D.1080000@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 08:56 PM, Ryan Mallon wrote:
> Okay, this was just the simplest solution I could come up with that
> fixed the issue for me. Is that a tentative acked/reviewed-by? :-).
>
> ~Ryan

I'm interested to see if anyone else has alternative ideas, but for now:

Reviewed-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
