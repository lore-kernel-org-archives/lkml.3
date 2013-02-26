Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab3BZDq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:46:27 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53714 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3BZDqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:46:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130226033524.GA25067@kroah.com>
References: <CAGsJ_4yxQK05hHUivYEnLD9=cAE4t5jNV7+6KJGu+LsVsSk1oQ@mail.gmail.com>
 <20130226033524.GA25067@kroah.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 26 Feb 2013 11:46:04 +0800
Message-ID: <CAGsJ_4za4tPZN6F=VG6A81OXZsU-d0S6YzwG2NT43E-kb8y52g@mail.gmail.com>
Subject: Re: what's the next LTSI kernel version for long-term support
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Binghua Duan <Binghua.Duan@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/26 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Tue, Feb 26, 2013 at 11:06:56AM +0800, Barry Song wrote:
>> Hi Greg/All,
>> we have seen 3.4 was announced to be an LTSI in Aug, 2012. I'd like to
>> know what is the next LTSI version since we might want to align our
>> next release with LTSI.
>
> Who is "we" here?
>
people.

>> That might help us to plan the release cycle.
>
> As I've stated before, I do not announce the long-term kernel ahead of
> time, we did that once in the past and it was a total mess.  I announce
> it _after_ the kernel is released.
>
> I have also stated that 3.8 is NOT going to be a long-term kernel, that
> would mean I would be handling 3 long-term kernels at once, plus 1-2
> "normal" stable kernels.  That is a sure way to drive me crazy and burn
> out.

if so, is there a time window for next LTSI? i am hoping there will be
another one in this year?

>
>> BTW, how many people and SoC vendors in ARM communicaty want to align
>> your releases with LTSI?
>
> I do not know.  There was an LTSI meeting last week at ELC where this
> was discussed, I suggest you ask the people who attended it. I was
> there, but it's not up to me to release the meeting minutes, and I
> wasn't taking notes, sorry.

ok.
>
> thanks,
>
> greg k-h

Thanks
barry
