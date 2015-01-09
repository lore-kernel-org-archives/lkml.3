Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbbAISbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:31:23 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:49370 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbbAISbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:31:21 -0500
MIME-Version: 1.0
In-Reply-To: <20150109171356.GC16970@qualcomm.com>
References: <1420757577-20425-1-git-send-email-agross@codeaurora.org>
	<1420757577-20425-2-git-send-email-agross@codeaurora.org>
	<4757751.7cLGsvPiZX@wuerfel>
	<20150109171356.GC16970@qualcomm.com>
Date: Fri, 9 Jan 2015 10:31:19 -0800
Message-ID: <CAJAp7OjYPCbQ54sbzeNBt9WZvxOFKOPNQG-GtE6XGCAxCehL=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] soc: qcom: Add TCSR driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Andy Gross <agross@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 9:13 AM, Andy Gross <agross@codeaurora.org> wrote:
> On Fri, Jan 09, 2015 at 01:06:56AM +0100, Arnd Bergmann wrote:
>> On Thursday 08 January 2015 16:52:56 Andy Gross wrote:
>> > This patch adds support for the TCSR (Top Control and Status Register) IP block
>> > that is present in the Qualcomm IPQ8064, APQ8064, and some later processors.
>> > This block contains additional configuration and mux settings for various
>> > peripherals in the system, including the ADM DMA block and USB controller.
>> >
>> > Signed-off-by: Andy Gross <agross@codeaurora.org>
>> >
>>
>> It sounds like this is a collection of random registers. Have you considered
>> making it a syscon node instead?
>
> That's a capital idea and solves my probe_defer issue more cleanly.  I'll rework
> and resend.
>

Then I guess I need to rework the tcsr-mutex driver to operate on top
a syson instead.

Do we want the same for the sfpb mutex or should I continue to ioremap for that?

Regards,
Bjorn
