Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961Ab3FSB37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:29:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59158 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644Ab3FSB35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:29:57 -0400
Message-ID: <51C10843.7070909@ti.com>
Date: Tue, 18 Jun 2013 20:24:19 -0500
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Benoit Cousson <benoit.cousson@linaro.org>, <balbi@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Philip Avinash <avinashphilip@ti.com>
Subject: Re: [PATCH 2/4] ARM: dts: AM33XX: Add PWMSS device tree nodes
References: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de> <1370526759-31163-3-git-send-email-bigeasy@linutronix.de> <51B89D78.6010906@linutronix.de> <20130612164026.GC22120@arwen.pp.htv.fi> <51C06255.2080208@linutronix.de>
In-Reply-To: <51C06255.2080208@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 06/18/2013 08:36 AM, Sebastian Andrzej Siewior wrote:
> On 06/12/2013 06:40 PM, Felipe Balbi wrote:
>> On Wed, Jun 12, 2013 at 06:10:32PM +0200, Sebastian Andrzej Siewior wrote:
>>> On 06/06/2013 03:52 PM, Sebastian Andrzej Siewior wrote:
>>>> From: Philip Avinash <avinashphilip@ti.com>
>>>>
>>>> Add PWMSS device tree nodes in relation with ECAP & EHRPWM DT nodes to
>>>> AM33XX SoC family. Also populates device tree nodes for ECAP & EHRPWM by
>>>> adding necessary properties like pwm-cells, base reg & set disabled as
>>>> status.
>>> Can someone please grab #2 till #4? Paul took just #1 as far as I can
>>> tell.
>>
>> DTS should be Benoit Cousson
>
> So, Benoit. Would you please be so kind and pick up the dts pieces?

That's done. Patches are available in 
git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git 
for_3.11/dts

Thanks,
Benoit
