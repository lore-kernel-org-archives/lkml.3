Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab3G0I6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 04:58:40 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:51114 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3G0I6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 04:58:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130725183824.GA32658@blackmetal.musicnaut.iki.fi>
References: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com>
 <51F07489.7010404@gmail.com> <CAD6i1fJO3geZ0vkHLsJEd+KedHkpC1OZVTJJskU2RAAKYBhhJQ@mail.gmail.com>
 <CAD6i1f+NYu7rcQwF-TXk4+OdjPNZwMKxxjJ9YA_+v9B6uPYq+g@mail.gmail.com>
 <CAHp75VdouA2w5WjBPJ2cX8AKvTeCNrj6pM+3SS5DzU+ARM5M3Q@mail.gmail.com>
 <CAP8WD_aKqqB4Fb4Vadj_AJ4ET5gxd+EkaCMMVvBxxqNwDjpBGg@mail.gmail.com>
 <CAHp75VeqgqVdn+zRjW+McwFQfD73NhYz4X3M4ndeDZnkFmqyEg@mail.gmail.com>
 <51F16F74.3070503@cogentembedded.com> <20130725183824.GA32658@blackmetal.musicnaut.iki.fi>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Sat, 27 Jul 2013 14:28:16 +0530
Message-ID: <CAD6i1fKra9Z8C=jm-KYuWPwxd=u-8HMo8b=XJJOo8aS+4SdmWg@mail.gmail.com>
Subject: Re: [PATCH] Change request_irq() to use struct net_device *dev->name
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>, whiteheadm@acm.org,
        Ryan Mallon <rmallon@gmail.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com, kernel-mentors@selenic.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 26, 2013 at 12:08 AM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Hi,
>
> On Thu, Jul 25, 2013 at 10:33:24PM +0400, Sergei Shtylyov wrote:
>>    It's also called managed device API. In fact, I've never heard it
>> named devres API.

If I understood it correctly it has to just calls
devm_request_region() with the struct device pointer and there are no
deallocation functions to call ? It manages deallocation on it own.

Regards.
