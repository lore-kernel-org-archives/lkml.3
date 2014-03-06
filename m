Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaCFLWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:22:23 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56857 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaCFLWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:22:21 -0500
MIME-Version: 1.0
In-Reply-To: <1394102406.25853.4.camel@AMDC1943>
References: <1394100057-32677-1-git-send-email-sachin.kamat@linaro.org>
	<1394100057-32677-2-git-send-email-sachin.kamat@linaro.org>
	<1394102406.25853.4.camel@AMDC1943>
Date: Thu, 6 Mar 2014 16:52:21 +0530
Message-ID: <CAK9yfHyv+PhLCfy131KCS4GWaAEgQ9qmS5X27bTYHWYUspkYjA@mail.gmail.com>
Subject: Re: [PATCH v3 Resend 2/3] regulator: Add support for S2MPA01 regulator
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 6 March 2014 16:10, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> On Thu, 2014-03-06 at 15:30 +0530, Sachin Kamat wrote:
>> Add support for S2MPA01 voltage and current regulator.

>> +
>> +struct s2mpa01_info {
>> +     struct regulator_dev *rdev[S2MPA01_REGULATOR_MAX];
>
> Hi,
>
> It seems that s2mpa01_info->rdev is not used anywhere, except as return
> value of devm_regulator_register. I think you can remove it completely.

Yes. I will send a follow up patch for this.

>
> Beside that, can this driver be merged into existing s2mps11 regulator
> driver?

Haven't analyzed this yet. Will look into the possibility of consolidation
later.

Thank you for your feedback.

-- 
With warm regards,
Sachin
