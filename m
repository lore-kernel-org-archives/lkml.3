Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3HMN6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:58:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53603 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab3HMN6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:58:17 -0400
Subject: Re: [PATCH] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex block
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CAK=WgbbdY-uZjiO2KBsYGshagykcL0X8PYEByb9K-Wp5R5g+hQ@mail.gmail.com>
Date: Tue, 13 Aug 2013 08:58:18 -0500
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <B26378B6-0E26-4EBA-A016-854EF2E01F1B@codeaurora.org>
References: <1375128719-23642-1-git-send-email-galak@codeaurora.org> <E9700EA7-7154-46C5-9258-03F030DF69F6@codeaurora.org> <20130729214035.GC8868@codeaurora.org> <9EB1A821-7137-4812-B58A-20F669BCA7DD@codeaurora.org> <0A09DA0F-86B4-4961-88E2-64FA0A4D380D@codeaurora.org> <CAK=WgbZSJmMz_U56ZsppBrB64XvTHBqJM4L+uFY1kKxhMCCtMQ@mail.gmail.com> <9BC13262-0803-4790-B1B5-0B46F7DB8D30@codeaurora.org> <CAK=WgbbdY-uZjiO2KBsYGshagykcL0X8PYEByb9K-Wp5R5g+hQ@mail.gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 13, 2013, at 1:01 AM, Ohad Ben-Cohen wrote:

> On Mon, Aug 12, 2013 at 8:24 PM, Kumar Gala <galak@codeaurora.org> wrote:
>> So I think I'd ask you to recommend a name, should we just us 'hwspinlock'.  The general view from ePAPR and dts is the node name should be a bit more generic (like ethernet or pci).  So what would you suggest?
> 
> How about 'hwlock' ?
> 
> This should be generic enough to cover all instances of hardware locks
> (we already know hwspinlock isn't generic enough, as there are some
> mutex-like hardware locks which doesn't require busy looping).

hwlock sounds good to me, I'll go with it.

- k

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

