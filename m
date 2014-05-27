Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaE0Roj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:44:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58334 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaE0Roh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:44:37 -0400
Message-ID: <5384CF04.8080106@codeaurora.org>
Date: Tue, 27 May 2014 10:44:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] coccinelle: Check for missing NULL terminators in of_device_id
 tables
References: <1400888504-31309-1-git-send-email-sboyd@codeaurora.org> <CAL_JsqJyCzNV0xK_uPp4o4F1Jhi8QmTY3KaHfeLcssnTea5H+Q@mail.gmail.com>
In-Reply-To: <CAL_JsqJyCzNV0xK_uPp4o4F1Jhi8QmTY3KaHfeLcssnTea5H+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/14 07:13, Rob Herring wrote:
> On Fri, May 23, 2014 at 6:41 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> Failure to terminate an of_device_id table can lead to confusing
>> failures depending on where the compiler places the array. Add a
>> check to make sure these tables are terminated. Thanks to Mitchel
>> Humpherys for coming up with the initial pattern.
> I've definitely debugged one of those problems. Do you have any actual
> fixes or there are no errors in the kernel?
>
>

Yes I sent five patches out. Here's one for example
https://lkml.org/lkml/2014/5/23/731

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

