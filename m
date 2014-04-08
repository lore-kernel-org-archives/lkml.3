Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbaDHOSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:18:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50656 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbaDHOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:18:46 -0400
Message-ID: <53440544.9040502@codeaurora.org>
Date: Tue, 08 Apr 2014 09:18:44 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com> 	 <1391700529-11816-2-git-send-email-iivanov@mm-sol.com> 	 <CAOZdJXVE7MSMBaL+bt0kjw5LEidz-aVp+vrWqQWkye6HdE7EeA@mail.gmail.com>  <1396959284.28420.45.camel@iivanov-dev> <5343EC87.700@codeaurora.org> <1396964805.28420.53.camel@iivanov-dev>
In-Reply-To: <1396964805.28420.53.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 08:46 AM, Ivan T. Ivanov wrote:
>> >This patch adds that same exact information into the device tree.  Why
>> >are we duplicating that information?  Why add it to the device tree when
>> >it's already in the driver (and already working).

> Probably. It was my natural way of thinking. Pin have a functions.
> It is easier if I measure signals to just look at the device
> tree file. What are you suggesting?

Back in July, Qualcomm submitted a patch that added this information 
into the device tree:

http://marc.info/?t=137185166100003&r=1&w=2

However, this was rejected.  Now it appears that this information is 
again being added to the device tree, but it's being accepted.  What's 
different now?

Another problem is that these device tree changes makes it difficult to 
support ACPI.  It's easy to move information between the drivers and the 
device tree, because they're kept together.  It's not so easy with ACPI. 
  I'm trying to add ACPI support to the 8x74 pinctrl driver, but it's a 
moving target.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by the Linux Foundation.
