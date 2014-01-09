Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaAIGnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 01:43:47 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59244 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbaAIGnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 01:43:41 -0500
Date: Wed, 8 Jan 2014 22:43:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ims-pcu: Add commands supported by the new version of
 the FW
Message-ID: <20140109064338.GA29893@core.coreip.homeip.net>
References: <1388623621-32245-1-git-send-email-andrew.smirnov@gmail.com>
 <20140104013957.GA19702@core.coreip.homeip.net>
 <CAHQ1cqEvXn3u2joA7dNaiz6fmHELnKjZTWF2F-7vvvBAx+9Drw@mail.gmail.com>
 <20140104044433.GA20272@core.coreip.homeip.net>
 <CAHQ1cqHJOi5mLptHSTw3W8dpdyJrUp8QnmCTtYdNX4YCTTNoaA@mail.gmail.com>
 <20140104054133.GC32576@core.coreip.homeip.net>
 <20140107071436.GB20074@core.coreip.homeip.net>
 <CAHQ1cqFaXCXw8UTwRVw72mmf7e_t3QjWNMshccEchsmR-2DVbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqFaXCXw8UTwRVw72mmf7e_t3QjWNMshccEchsmR-2DVbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 09:57:20PM -0800, Andrey Smirnov wrote:
> On Mon, Jan 6, 2014 at 11:14 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > Andrey, were you able to test the patch?
> 
> Hi Dmitry,
> 
> I tested the patch and with exception of a trivial to fix typo/bug it
> worked fine.
> 
> I see that you moved the OFN attributes to a dedicated directory,
> which I personally like better, but I am not sure if IMS would not
> want to push back on it since they might have started to use the API
> already. I'll send a new version to Chris so that he can do some
> additional testing and see if they can incorporate that naming change.
> I'll e-mail you v3 of the patch as soon as that matter becomes more
> clear.

Andrey,

I am pretty sure that the new sysfs layout with OFN group split makes
most sense. Luckily this is brand new functionality so IMS should be
able to adjust their userspace to accommodate it.

Thanks.

-- 
Dmitry
