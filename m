Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaGPWW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:22:28 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:52255 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaGPWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:22:25 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 18:22:25 EDT
MIME-Version: 1.0
In-Reply-To: <CAMf-jSn2YHF7ihRpXMfkPWYt8pNCj4o395OGha3BHD3K3mUv9g@mail.gmail.com>
References: <1405465241-28684-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1405465241-28684-4-git-send-email-bjorn.andersson@sonymobile.com>
	<CAMf-jSn2YHF7ihRpXMfkPWYt8pNCj4o395OGha3BHD3K3mUv9g@mail.gmail.com>
Date: Wed, 16 Jul 2014 15:17:13 -0700
Message-ID: <CAJAp7Oj1R-EkJoSdLEa6SBLbzE_N1MjsystQ9Z+x4L_SjU=56w@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
From: Bjorn Andersson <bjorn@kryo.se>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 12:01 AM, pramod gurav
<pramod.gurav.etc@gmail.com> wrote:
> Hi Bjorn,
>
> On Wed, Jul 16, 2014 at 4:30 AM, Bjorn Andersson
> <bjorn.andersson@sonymobile.com> wrote:
[...]
>> +static const struct regulator_linear_range pldo_ranges[] = {
>> +       REGULATOR_LINEAR_RANGE( 750000,   0,  59, 12500),
>
> ERROR: space prohibited after that open parenthesis '('
>

I prefer the nicely aligned columns over checkpatch correctness here.

>> +       REGULATOR_LINEAR_RANGE(1500000,  60, 123, 25000),
>> +       REGULATOR_LINEAR_RANGE(3100000, 124, 160, 50000),
>> +};
>> +

Regards,
Bjorn
