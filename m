Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaIIU4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:56:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55621 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaIIU4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:56:24 -0400
Date: Tue, 9 Sep 2014 22:56:19 +0200
From: Pavel Machek <pavel@denx.de>
To: Olof Johansson <olof@lixom.net>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek =?utf-8?B?VmHFoXV0?= <marex@denx.de>
Subject: Re: [PATCH] fix mmc hang during boot on socfpga
Message-ID: <20140909205618.GA32688@amd>
References: <20140909121902.GA22965@amd>
 <CAOesGMgvqvQw2WzdQWQ7NSE_CKgH0MR-46UABkck0cQbpV4P=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgvqvQw2WzdQWQ7NSE_CKgH0MR-46UABkck0cQbpV4P=g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-09-09 10:32:14, Olof Johansson wrote:
> On Tue, Sep 9, 2014 at 5:19 AM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> > Without this patch, boot hangs when trying to mount root filesystem on
> > socfpga platform in about 50% cases.
> 
> I think this should have a better description than this -- this is too
> vague. Did it use to always work, is this a new failure? You enable
> some more error checking and improved stop handling, why was the
> previous one inadequate on this platform?

I don't think it ever worked reliably. I don't know what is different
for socfpga, or if it is broken on other platforms, too. I have two
socfpga boards here, but no other dw_mmc board.

Patch was separated from rocketboards.org repository.

Hope this helps,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
