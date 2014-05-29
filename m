Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516AbaE2J1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:27:18 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:57676 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbaE2J1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140529091255.GB24233@leverpostej>
References: <1401185895-3677-1-git-send-email-harinik@xilinx.com>
	<1401185895-3677-2-git-send-email-harinik@xilinx.com>
	<20140529091255.GB24233@leverpostej>
Date: Thu, 29 May 2014 14:57:15 +0530
Message-ID: <CAFcVECJXK4fFGV1iDm79Y6=xvPnPvzqWzL_XHMYuP_PTv7CZHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] devicetree: Add Cadence WDT devicetree bindings documentation
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, May 29, 2014 at 2:42 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, May 27, 2014 at 11:18:15AM +0100, Harini Katakam wrote:
>> Add cadence-wdt bindings documentation.
>>
>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>> ---
>>
>> v2:
>> No changes

<snip>

>> +Optional properties
>> +- reset                      : Reset interrupt.
>
> What does this mean? What type is this?
>
> I have no idea if this is a boolean telling the OS to reset the
> interrupt initially, or an index describing which interrupt is the reset
> interrupt in either the interrupts property or some HW registers.
>

The watchdog has an option to automatically reset when the counter
reaches zero. This property is an input based on which this automatic
reset is enabled or disabled.
I will improve the description of this property.

Regards,
Harini
