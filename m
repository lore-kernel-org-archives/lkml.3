Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967102Ab3HIA4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:56:04 -0400
Received: from void.printf.net ([89.145.121.20]:56406 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967013Ab3HIA4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:56:00 -0400
From: Chris Ball <cjb@laptop.org>
To: Olof Johansson <olof@lixom.net>
Cc: Doug Anderson <dianders@google.com>, James Hogan <james.hogan@imgtec.com>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: dw_mmc: Does anyone use multiple slots?
References: <CAD=FV=U3aT1KKtSwAFhYURJJerp70ij8h647=xyV51et4jYipg@mail.gmail.com>
	<CAOesGMjaF2K0CnuWBj7xdXGAQk-XRetBstaQdd9EZzBYrmDjeA@mail.gmail.com>
Date: Fri, 09 Aug 2013 01:55:44 +0100
In-Reply-To: <CAOesGMjaF2K0CnuWBj7xdXGAQk-XRetBstaQdd9EZzBYrmDjeA@mail.gmail.com>
	(Olof Johansson's message of "Thu, 8 Aug 2013 17:19:44 -0700")
Message-ID: <86mworfzsf.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 09 2013, Olof Johansson wrote:
> On Thu, Aug 8, 2013 at 5:16 PM, Doug Anderson <dianders@google.com> wrote:
>
>> I guess my overall question is: if there are no actual implementations
>> of multislot, shouldn't we kill it and simplify the code a whole lot?
>> If someone out there has a real multislot device they can step back in
>> and do it more correctly?
>>
>> Of course we need to find someone to actually go through and do the
>> killing of multislot, but finding that person might be easier if there
>> was some agreement that it was good to do.
>
> There clearly seems to be no in-tree users of multislot. If someone
> new comes in, we have the code in the history and can revert the
> removal (or at least use it as reference for re-introduction).
>
> I vote for removing it. It adds really annoying complexity for
> something that nobody uses.

I agree with Olof, for what it's worth.  (The maintainers of the
driver are Jaehoon and Seungwon, though.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
