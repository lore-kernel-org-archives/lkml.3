Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaIQK0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:26:50 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:46931 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbaIQK0q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:26:46 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Date: Wed, 17 Sep 2014 06:26:44 -0400 (EDT)
Subject: Re: [PATCH v3] ARM: apq8064: Add pinmux and i2c pinctrl nodes
From: kiran.padwal@smartplayin.com
To: "Kumar Gala" <galak@codeaurora.org>
Cc: "Andy Gross" <agross@codeaurora.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org, afaerber@suse.de,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <96034F94-3C6D-43FC-95EF-7FA705724F99@codeaurora.org>
References: <1409052645-14984-1-git-send-email-kiran.padwal@smartplayin.com>  
 <20140916023922.GB2386@qualcomm.com> 
 <1410871001.891126377@apps.rackspace.com> 
 <96034F94-3C6D-43FC-95EF-7FA705724F99@codeaurora.org>
Message-ID: <1410949604.906729871@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday, September 16, 2014 3:00pm, "Kumar Gala" <galak@codeaurora.org> said:

> 
> On Sep 16, 2014, at 5:36 AM, kiran.padwal@smartplayin.com wrote:
> 
>>
>>
>> On Monday, September 15, 2014 10:39pm, "Andy Gross" <agross@codeaurora.org>
>> said:
>>
>>> On Tue, Aug 26, 2014 at 05:00:45PM +0530, Kiran Padwal wrote:
>>>> This patch adds pinmux and i2c pinctrl DT node for IFC6410 board.
>>>> It also adds necessary DT support for i2c eeprom which is present on
>>>> IFC6410.
>>>>
>>>> Tested on IFC6410 board.
>>>
>>> Looks fine
>>
>> Thanks for review.
> 
> Can you rebase this on:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git
> tags/qcom-dt-for-3.18

Sure, I will resend this patch gain.

> 
> - k
> 
> --
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The
> Linux Foundation
> 
> 


