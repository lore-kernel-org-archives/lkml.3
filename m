Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3KERqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:46:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:32910 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3KERqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:46:32 -0500
Message-ID: <52792EF6.2040005@codeaurora.org>
Date: Tue, 05 Nov 2013 09:46:30 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/11] devicetree: bindings: Document Qualcomm cpus and
 enable-method
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-3-git-send-email-sboyd@codeaurora.org> <CAL_JsqLObXEWJJ=SuifTjpPz9qTW0n43fyQNA-vjLNeLy-7-XA@mail.gmail.com> <20131104173606.GL21983@codeaurora.org> <378446F7-DC51-448D-AF99-93F98CEAFB03@codeaurora.org> <52792C60.2030405@codeaurora.org> <1A27B0E2-FB92-488D-A0B3-65E677525720@codeaurora.org>
In-Reply-To: <1A27B0E2-FB92-488D-A0B3-65E677525720@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 09:43, Kumar Gala wrote:
> On Nov 5, 2013, at 11:35 AM, Stephen Boyd wrote:
>
>> On 11/05/13 09:12, Kumar Gala wrote:
>>> I think this should be more specific than just 'qcom,mmio' or 'qcom,warm-boot'.  It should be 'qcom,kpss-acc-v1' or 'qcom-gcc-8660'.
>>>
>> Do you have any reasons why? I don't see why we need to keep adding more
>> and more enable-methods every time the subsystem surrounding the CPU
>> changes. The method is the same, write some registers to power up the
>> CPU for the first time (cold boot) or ping the CPU to wake it up
>> (warmboot). The only difference is where those registers live and a
>> slight variation in the sequence that we perform.
> By that argument every device could just be compatible with 'mmio' and be done with it ;)
>
> As the registers you write vary, the compatible should vary.

The compatible does vary. The enable-method is not a compatible property.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

