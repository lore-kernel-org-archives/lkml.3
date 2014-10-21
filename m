Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaJUMww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:52:52 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36046 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbaJUMwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:52:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141020092005.GD4370@arm.com>
References: <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
	<9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
	<20140513184503.GF16388@arm.com>
	<9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com>
	<537337F3.4080300@arm.com>
	<9034CBD80F070943B59700D7F8149ED9A0875776@SC-VEXCH4.marvell.com>
	<9034CBD80F070943B59700D7F8149ED90182308172@SC-VEXCH4.marvell.com>
	<20140703175706.GI17372@arm.com>
	<9034CBD80F070943B59700D7F8149ED9024EB81CD8@SC-VEXCH4.marvell.com>
	<5444D2E0.9070205@arm.com>
	<20141020092005.GD4370@arm.com>
Date: Tue, 21 Oct 2014 14:52:49 +0200
Message-ID: <CANLsYkziaqnVkOGpnzEHLiS35JHc2Sd_yTz_ruWpwE=JMZyvxw@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Sudeep Holla <Sudeep.Holla@arm.com>, Neil Zhang <zhangwm@marvell.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2014 11:20, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Oct 20, 2014 at 10:16:16AM +0100, Sudeep Holla wrote:
>> On 20/10/14 09:46, Neil Zhang wrote:
>> > Will, I prefer to check always-on field under PMU node to check
>> > whether we need Save/restore them.
>> >
>> But how do you handle it for different idle states. e.g. if CPU is in
>> retention, PMU's *might be* retained. Also I don't think PMUs will be
>> placed in "always-on" power domain like timers. So using "always-on"
>> sounds incorrect to me.
>
> Adding Mathieu to CC, since I spoke to him at LPC about this and he was
> talking about implementing proper PM domain descriptions for coresight
> components.
>
> Will

Will is correct - it's in the pipeline now.  Just hang tight.
