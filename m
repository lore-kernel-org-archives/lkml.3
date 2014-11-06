Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaKFSYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:24:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60387 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaKFSYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:24:43 -0500
Message-ID: <545BBCCB.7030107@ti.com>
Date: Thu, 6 Nov 2014 12:24:11 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Bjorn Andersson <bjorn@kryo.se>, Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 4/7] hwspinlock/core: add common OF helpers
References: <1389658764-39199-1-git-send-email-s-anna@ti.com> <1389658764-39199-5-git-send-email-s-anna@ti.com> <CAJAp7Oj-3ZxvN8o=rg8YeTiXYWyQ1iowgisdU1R5UcZeh4VmOQ@mail.gmail.com> <5425938C.6070007@ti.com> <CAK=WgbYf3++K4MVXW_n4zj-8fMEee61XG5+r40cW=trapRtJ7w@mail.gmail.com>
In-Reply-To: <CAK=WgbYf3++K4MVXW_n4zj-8fMEee61XG5+r40cW=trapRtJ7w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 10/06/2014 04:44 AM, Ohad Ben-Cohen wrote:
> On Fri, Sep 26, 2014 at 7:25 PM, Suman Anna <s-anna@ti.com> wrote:
>> I am yet to receive any comments on v6, but that series should address
>> both your need for a probe deferral and Ohad's request to not change any
>> return types. Please give it a try and let me know if you have any comments.
> 
> Guys,
> 
> Just to let you know we have several holidays around here these days,
> and I intend to review all pending patches immediately soon after.
> 

Ping on this. Can you review the latest series v6 [1] and pick it up for
3.19? The MSM spinlock driver is also blocked/dependent on that series.

regards
Suman

[1] http://marc.info/?l=linux-arm-kernel&m=141055365513902&w=2
