Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3ILRGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:06:36 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:38109 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3ILRGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:06:34 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <25E0B143-658E-4CCC-A88A-0AF70FFF33CE@codeaurora.org>
References: <1379003839-16068-1-git-send-email-galak@codeaurora.org>
	<CAOesGMisWLwYKotGDFPW6PyHJs=_+fohTdC08SGjsv2FXaa7Fg@mail.gmail.com>
	<25E0B143-658E-4CCC-A88A-0AF70FFF33CE@codeaurora.org>
Date: Thu, 12 Sep 2013 10:06:33 -0700
Message-ID: <CAOesGMhfdvyJ_2AA2e8iO_2e=q7KgpyNbcriPKFw-RLormG6bA@mail.gmail.com>
Subject: Re: [PATCH] ARM: msm: Move msm devicetrees under a Qualcomm dir
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 9:53 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Sep 12, 2013, at 11:46 AM, Olof Johansson wrote:
>
>> On Thu, Sep 12, 2013 at 9:37 AM, Kumar Gala <galak@codeaurora.org> wrote:
>>> Use the Qualcomm vendor prefix (qcom) as the directory name for
>>> Qualcomm MSM devicetrees going forward.
>>>
>>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>>
>> Let's not move just one platform like this. If we are to do this, we
>> should move everything, and that will be really painful and needs to
>> be done in a controlled manner, probably scripted and right before a
>> -rc1 or such.
>
>
> Than I suggest we deal with it when we pull the device trees out of the kernel tree.
>
> As such, I'd tell Rohit to go forward with the file being named apq8074-dragonboard.dtb for the time being.

My original request to please use a common prefix for your product
families stands. Please prefix with msm-*, or if you have to, qcom-*
instead, since you guys can't seem to make your mind up on standard
prefixes (msm, apq, etc).


-Olof
