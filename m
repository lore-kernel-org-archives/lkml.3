Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaILQUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:20:00 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52044 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaILQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:19:57 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9c-54131d2b8b65
Message-id: <1410538794.8852.35.camel@AMDC723>
Subject: Re: [PATCH] PM / Domains: add debugfs listing of struct
 generic_pm_domain-s
From: Maciej Matraszek <m.matraszek@samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux-sh list <linux-sh@vger.kernel.org>
Date: Fri, 12 Sep 2014 18:19:54 +0200
In-reply-to: <CAMuHMdV74C+iFXXGjKAfvjd8NjKQDwcm1bJja41cscbip_ePZg@mail.gmail.com>
References: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
 <CAMuHMdUi9sZFZa2pcAWvHi1xmZfhEUyCbW0uRt65QwkbTqEjYg@mail.gmail.com>
 <1410453908.8852.9.camel@AMDC723>
 <CAMuHMdV74C+iFXXGjKAfvjd8NjKQDwcm1bJja41cscbip_ePZg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xy7rassIhBie/K1psnLGe1eLZrb1M
	Fs2L17NZvH5haDFrCpB3edccNovPvUcYLeb8mcJscffUUTaLM6cvsTpweSze85LJ49DhDkaP
	/XPXsHtsudrO4tG3ZRWjx4rV39k9Pm+SC2CP4rJJSc3JLEst0rdL4Mp4NWkOS8E6loqn056w
	NTBuYO5i5OSQEDCRmNb9mAXCFpO4cG89WxcjF4eQwFJGiUenZzFCOJ8ZJRa9Wc4OUsUroCfR
	0H4XrFtYIEziT/9mVhCbTcBAYvO/fqBJHBwiAroSc34ygfQyC8xjlvi1tZcZJM4ioCqx+rUl
	iMkpECyxY78vxPifjBKTvzSCjWQWUJeYNG8RWLmEgLJEY78bxFZBiR+T77FAlMhLbF7zlnkC
	o8AsJB2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZITHzZwbj4mNUhRgEO
	RiUeXo5zgiFCrIllxZW5hxglOJiVRHgVRYVDhHhTEiurUovy44tKc1KLDzEycXBKNTDOviDG
	IHzpatT5BzcvBkhanUhzSze5vOlVQtGFaA8j0XlVN04mv/zNLDxNeN9z2fST++ycUt9WXdHp
	utXcySE3aXbxqufVK5dX8hq/8FrIcmT5dkcz7+oQrp075boWHTx2VuHrnG26676G2r1V6u55
	VT9PoEh78UqpF86uEyvcouftV2Y4k6KsxFKckWioxVxUnAgAtl3Sq2cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-09-11 at 19:27 +0200, Geert Uytterhoeven wrote:
> Hi Maciej,
> 
> On Thu, Sep 11, 2014 at 6:45 PM, Maciej Matraszek
> <m.matraszek@samsung.com> wrote:
> > BTW Can I use your output as example in the commit message for v2?
> > It's much more informative
> 
> Sure, no problem.
> 
> > (though 'runtime status' alignment seems odd).
> 
> What's wrong with it?

Nothing big, just for such short device names it doesn't look aesthetic to me :).

Regards,
-- 
Maciej Matraszek
Samsung R&D Institute Poland
Samsung Electronics


