Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547AbaE2SOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:14:04 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47064 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbaE2SOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:14:02 -0400
MIME-Version: 1.0
In-Reply-To: <8CA95B37-E5EE-46BE-ABFD-64AA3BBF4E96@codeaurora.org>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
	<F773CDFB-2957-49C0-99D3-E9CDCE33C378@codeaurora.org>
	<CAJAp7Ojb7PvuNYJkPyKx+iehi0bF6rdYvYmfrDz21mebxMN1qg@mail.gmail.com>
	<8CA95B37-E5EE-46BE-ABFD-64AA3BBF4E96@codeaurora.org>
Date: Thu, 29 May 2014 11:14:00 -0700
Message-ID: <CAJAp7OjYSPLiJXOfY_v=zC+S-_1ryFw29Du6mcp9nQ3v_cj5Jw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Qualcomm Resource Power Manager driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:06 AM, Kumar Gala <galak@codeaurora.org> wrote:
> It is the purpose so that as we see common patterns between either drivers/soc/<VENDOR> we can refactor in the future.  However, we need to all a little time for those patterns to emerge rather than shoe horning in drivers into places that don’t make sense.

Sounds reasonable, I'll move it for v2.

>
>>
>> If I move the rpm driver, are there any conclusion to where I should
>> move the dt binding documentation?
>
> devicetree/bindings/soc/qcom
> include/dt-bindings/soc

Thanks.

Regards,
Bjorn
