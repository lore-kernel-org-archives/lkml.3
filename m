Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab3IBLaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:30:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab3IBLaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:30:11 -0400
Date: Mon, 2 Sep 2013 13:30:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Correct the USB IDs for the new Macbook Air 6
In-Reply-To: <1378042304-1400-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1309021329510.3796@pobox.suse.cz>
References: <1378042304-1400-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Sep 2013, Henrik Rydberg wrote:

> A recent patch (9d9a04ee) added support for the new machine, but got
> the sequence of USB ids wrong. Reports from both Ian and Linus T show
> that the 0x0291 id is for ISO, not ANSI, which should have the missing
> number 0x0290. This patchs moves the three numbers accordingly, fixing
> the problem.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Reported-and-tested-by: Ian Munsie <darkstarsword@gmail.com>
> Tested-by: Linus G Thiel <linus@hanssonlarsson.se>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Jiri, Dmitry,
> 
> it looks like this change has been sufficiently tested now, in
> addition to making perfect sense. Jiri, would you mind taking it, if
> Dmitry approves?

Absolutely ... waiting for Dmitry's Ack.

Thanks,

-- 
Jiri Kosina
SUSE Labs
