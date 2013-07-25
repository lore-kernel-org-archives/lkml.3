Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab3GYSdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:33:35 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:60757 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661Ab3GYSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:33:31 -0400
Message-ID: <51F16F74.3070503@cogentembedded.com>
Date: Thu, 25 Jul 2013 22:33:24 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: whiteheadm@acm.org, Prashant Shah <pshah.mumbai@gmail.com>,
        Ryan Mallon <rmallon@gmail.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com, kernel-mentors@selenic.com
Subject: Re: [PATCH] Change request_irq() to use struct net_device *dev->name
References: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com> <51F07489.7010404@gmail.com> <CAD6i1fJO3geZ0vkHLsJEd+KedHkpC1OZVTJJskU2RAAKYBhhJQ@mail.gmail.com> <CAD6i1f+NYu7rcQwF-TXk4+OdjPNZwMKxxjJ9YA_+v9B6uPYq+g@mail.gmail.com> <CAHp75VdouA2w5WjBPJ2cX8AKvTeCNrj6pM+3SS5DzU+ARM5M3Q@mail.gmail.com> <CAP8WD_aKqqB4Fb4Vadj_AJ4ET5gxd+EkaCMMVvBxxqNwDjpBGg@mail.gmail.com> <CAHp75VeqgqVdn+zRjW+McwFQfD73NhYz4X3M4ndeDZnkFmqyEg@mail.gmail.com>
In-Reply-To: <CAHp75VeqgqVdn+zRjW+McwFQfD73NhYz4X3M4ndeDZnkFmqyEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/25/2013 10:31 PM, Andy Shevchenko wrote:

>> Andy,
>>    I can't find a single example of a devres_* call in
>> drivers/net/ethernet/*. Does any networking code exist that we can look at
>> as an example for conversion to the devres API?

> devres API usually means managed version of the functions that used
> mostly at probe() stage.
> For example, devm_*() or pcim_*() calls.

    It's also called managed device API. In fact, I've never heard it named 
devres API.

WBR, Sergei

