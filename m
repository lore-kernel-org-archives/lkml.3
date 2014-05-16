Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbaEPQnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:43:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51611 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaEPQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:43:50 -0400
Message-ID: <53764045.5090603@codeaurora.org>
Date: Fri, 16 May 2014 09:43:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1 01/11] ARM: amba: Add Qualcomm vendor ID.
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org> <1398759542-13017-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdZyEAkJUGC5x6CY65-g97jfyg-TMDoe8JxDMexVx5usSA@mail.gmail.com> <5371E8B7.8000103@linaro.org> <20140513221313.GI20486@codeaurora.org> <CACRpkdZe7NA0CxB=ArWwSRt_BF69sG=BHBz+DY1H4AbabNhC=A@mail.gmail.com>
In-Reply-To: <CACRpkdZe7NA0CxB=ArWwSRt_BF69sG=BHBz+DY1H4AbabNhC=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/14 09:24, Linus Walleij wrote:
> On Wed, May 14, 2014 at 12:13 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> Please add a note that this id is fake in the commit text or in
>> the code as well.
> You just need one of your hardware engineers to add is to one instance
> of some test chip round so it exists in any hardware whatsoever and it
> is not "fake" anymore...
>
> This is a bit like device tree, it's defined by the kernel community as much
> as by the hardware engineers and it's a little bit of back-and-forth.
>

Sure, but hardware teams have moved on from this IP so I doubt we can
even get them to put it into a test chip. In fact, the devices a
generation before the ones Srini is working on (msm8660 for example)
have a periph ID of 0x41180 so we need to override that ID in DT with
this fake ID for things to even work.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

