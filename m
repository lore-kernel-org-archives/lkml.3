Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaDURDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:03:33 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:65474 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaDURD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:03:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140421161442.GC22794@saruman.home>
References: <1396649891-2880-1-git-send-email-tim.bird@sonymobile.com>
	<20140421161442.GC22794@saruman.home>
Date: Mon, 21 Apr 2014 10:03:28 -0700
Message-ID: <CA+bK7J7Psj=7nORhidbV6MrifmCY9ZgE0GjYzAPaaKK7=wHgvg@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: msm: Select secondary PHY via TCSR
From: Tim Bird <tbird20d@gmail.com>
To: balbi@ti.com
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-arm-msm@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 9:14 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Apr 04, 2014 at 03:18:11PM -0700, Tim Bird wrote:
>> Select the secondary PHY using the TCSR register, if phy-num=1
>> in the DTS (or phy_number is set in the platform data).  The
>> SOC has 2 PHYs which can be used with the OTG port, and this
>> code allows configuring the correct one.
>>
>> Note: This resolves the problem I was seeing where I couldn't
>> get the USB driver working at all on a dragonboard, from cold
>> boot.  This patch depends on patch 5/14 from Ivan's msm USB
>> patch set.  It does not use DT for the register address, as
>> there's no evidence that this address changes between SoC
>> versions.
>>
>> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
>
> doesn't apply:
>
> checking file drivers/usb/phy/phy-msm-usb.c
> Hunk #1 succeeded at 1412 with fuzz 2 (offset -106 lines).
> Hunk #2 FAILED at 1581.
> 1 out of 2 hunks FAILED
> checking file include/linux/usb/msm_hsusb_hw.h

Sorry about that.

Did you apply this on top of Ivan's USB patch set?  That's a pre-requisite.

I've communicated privately with Ivan, and he's preparing an updated
patch set which incorporates this fix and a few other things. This should
be showing up soon-ish.
 -- Tim

Senior Software Engineer, Sony Mobile
Architecture Group Chair, CE Workgroup, Linux Foundation
