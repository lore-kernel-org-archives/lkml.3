Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3FCIyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:54:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47873 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3FCIyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:54:08 -0400
Message-ID: <51AC59AB.4080802@arm.com>
Date: Mon, 03 Jun 2013 09:54:03 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv6 00/11] Remove ARM local timer API
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org> <20130531174526.GD599@codeaurora.org> <51A8E71D.1000407@linaro.org> <20130531221633.GG599@codeaurora.org>
In-Reply-To: <20130531221633.GG599@codeaurora.org>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 03 Jun 2013 08:54:03.0955 (UTC) FILETIME=[E60F4030:01CE6037]
X-MC-Unique: 113060309540600401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/13 23:16, Stephen Boyd wrote:
> On 05/31, John Stultz wrote:
>> On 05/31/2013 10:45 AM, Stephen Boyd wrote:
>>> Comments have been light for this round so I think we're about
>>> ready to merge. John/Thomas, can you pick up these patches or
>>> shall I route them through arm-soc or something else?
>>
>>
>> So there looks to be a fair amount of additions in the ARM tree, do
>> those already have acks from Arnd/Olof/other folks? (I think I was
>> only cc'ed on the first two patches).
> 
> I'm still missing acks from Kukjin and Barry.

I don't think that should hold off the patch series. It's been tested on
most other platforms over the course of several months. If the platform
maintainers aren't responsive enough, fixing the issues becomes their
problem.

FWIW, have my
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...

