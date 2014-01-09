Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaAIF5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:57:23 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39397 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaAIF5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:57:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140107071436.GB20074@core.coreip.homeip.net>
References: <1388623621-32245-1-git-send-email-andrew.smirnov@gmail.com>
	<20140104013957.GA19702@core.coreip.homeip.net>
	<CAHQ1cqEvXn3u2joA7dNaiz6fmHELnKjZTWF2F-7vvvBAx+9Drw@mail.gmail.com>
	<20140104044433.GA20272@core.coreip.homeip.net>
	<CAHQ1cqHJOi5mLptHSTw3W8dpdyJrUp8QnmCTtYdNX4YCTTNoaA@mail.gmail.com>
	<20140104054133.GC32576@core.coreip.homeip.net>
	<20140107071436.GB20074@core.coreip.homeip.net>
Date: Wed, 8 Jan 2014 21:57:20 -0800
Message-ID: <CAHQ1cqFaXCXw8UTwRVw72mmf7e_t3QjWNMshccEchsmR-2DVbw@mail.gmail.com>
Subject: Re: [PATCH v2] ims-pcu: Add commands supported by the new version of
 the FW
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 11:14 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> Andrey, were you able to test the patch?

Hi Dmitry,

I tested the patch and with exception of a trivial to fix typo/bug it
worked fine.

I see that you moved the OFN attributes to a dedicated directory,
which I personally like better, but I am not sure if IMS would not
want to push back on it since they might have started to use the API
already. I'll send a new version to Chris so that he can do some
additional testing and see if they can incorporate that naming change.
I'll e-mail you v3 of the patch as soon as that matter becomes more
clear.

Thanks,
Andrey
