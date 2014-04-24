Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaDXEn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:43:58 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43399 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaDXEn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAM4v1pMRiWkUx0YboOkcYXDt=quXiR7FWs0b=HjzbRG+sdnPFA@mail.gmail.com>
References: <CAKohpokPSVTJ5rupW8vM0btgtc9S6bWdgCdDkn6qHK5SfcGX0A@mail.gmail.com>
	<CAM4v1pMRiWkUx0YboOkcYXDt=quXiR7FWs0b=HjzbRG+sdnPFA@mail.gmail.com>
Date: Thu, 24 Apr 2014 10:13:56 +0530
Message-ID: <CAKohpomHgtow=L8CQ8XA6NrXza1g9k0j2by-GR2erB4=7Oexhg@mail.gmail.com>
Subject: Re: [Query]: hrtimers: why don't we consider hrtimers in get_next_timer_interrupt()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

On 23 April 2014 17:54, Preeti Murthy <preeti.lkml@gmail.com> wrote:
> On Wed, Apr 23, 2014 at 3:08 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> In case of high resolution mode, the clock device would have
> already been programmed for the upcoming hrtimer, the last
> time the list of hrtimers was evaluated. So we have
> already taken care of hrtimers to expire next.

I actually missed this part and things look correct with this. We aren't
choosing the next device event here but just the next time we need
tick.

Thanks.
