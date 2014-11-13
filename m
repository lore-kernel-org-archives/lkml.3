Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbaKMW1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:27:07 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:53184 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:27:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141113191704.GA28033@kroah.com>
References: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
	<CANLsYkyPnVJ75-TYYionMtd2KJzs29UK9LD3Fj4vk=Apvfh0Gw@mail.gmail.com>
	<20141113191704.GA28033@kroah.com>
Date: Thu, 13 Nov 2014 15:27:05 -0700
Message-ID: <CANLsYkw5vi5cFpyPkSS6Ypn8M=gznqb20TOc6HzM=yTGEDakrQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] miscellaneous fixes in coresight
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pratik Patel <pratikp@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I took them in my tree and I'll send you a pull request.

On 13 November 2014 12:17, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 13, 2014 at 11:12:40AM -0700, Mathieu Poirier wrote:
>> On 13 November 2014 01:42, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
>> > This patch series fixes some typo and minor issues in coresight which
>> > I observed while going through this driver.
>> >
>> > Pankaj Dubey (3):
>> >   coresight: fix typo in comment in coresight-priv.h
>> >   coresight: fixed comments in coresight.h
>> >   coresight-replicator: remove .owner field for driver
>> >
>> >  drivers/coresight/coresight-priv.h       |    2 +-
>> >  drivers/coresight/coresight-replicator.c |    1 -
>> >  include/linux/coresight.h                |    6 +++---
>> >  3 files changed, 4 insertions(+), 5 deletions(-)
>> >
>> > --
>> > 1.7.9.5
>> >
>>
>> Applied all 3 patches - thanks
>
> Applied to what?  Shouldn't I be taking these?
>
> confused,
>
> greg k-h
