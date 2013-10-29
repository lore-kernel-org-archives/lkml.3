Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3J2I00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:26:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37026 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab3J2I0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:26:21 -0400
Subject: Re: [PATCH v2 1/2] clk/zynq/clkc: Add 'fclk-enable' feature
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <2028580.HhySWWnU2A@flatron>
Date: Tue, 29 Oct 2013 03:26:20 -0500
Cc: =?iso-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <8864256B-F8F9-4474-9B5F-416C3BB96523@codeaurora.org>
References: <1381425018-5653-1-git-send-email-soren.brinkmann@xilinx.com> <1592656.1ojHcSlzVh@flatron> <b7840a0d-ac49-4c2d-beaa-9f79748c70d0@CH1EHSMHS006.ehs.local> <2028580.HhySWWnU2A@flatron>
To: Tomasz Figa <tomasz.figa@gmail.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28, 2013, at 5:17 PM, Tomasz Figa wrote:

>>>> diff --git a/Documentation/devicetree/bindings/clock/zynq-7000.txt
>>>> b/Documentation/devicetree/bindings/clock/zynq-7000.txt index
>>>> d99af878f5d7..11fdd146ec83 100644
>>>> --- a/Documentation/devicetree/bindings/clock/zynq-7000.txt
>>>> +++ b/Documentation/devicetree/bindings/clock/zynq-7000.txt
>>>> 
>>>> @@ -22,6 +22,10 @@ Required properties:
>>>> Optional properties:
>>>>  - clocks : as described in the clock bindings
>>>>  - clock-names : as described in the clock bindings
>>>> 
>>>> + - fclk-enable : Bit mask to enable FCLKs in cases no proper CCF
>>> 
>>> Since it's a vendor specific property, it should include vendor
>>> prefix.
>> 
>> The whole driver is vendor specific. Should there really be another
>> prefix for that property?
> 
> Yes. If a property is introduced just for use by this particular driver 
> then it must be prepended by a vendor prefix. That's a general rule.

Most all nodes are vendor specific by definition ;).

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

