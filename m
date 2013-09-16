Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3IPS2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:28:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46219 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3IPS2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:28:36 -0400
Message-ID: <52374DD1.9040209@codeaurora.org>
Date: Mon, 16 Sep 2013 11:28:33 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: msm: Move msm devicetrees under a Qualcomm dir
References: <1379003839-16068-1-git-send-email-galak@codeaurora.org> <CAOesGMisWLwYKotGDFPW6PyHJs=_+fohTdC08SGjsv2FXaa7Fg@mail.gmail.com> <25E0B143-658E-4CCC-A88A-0AF70FFF33CE@codeaurora.org> <CAOesGMhfdvyJ_2AA2e8iO_2e=q7KgpyNbcriPKFw-RLormG6bA@mail.gmail.com> <3E38F48E-EE41-4564-84A1-36CF07B08811@codeaurora.org> <20130912224737.GA24937@codeaurora.org> <9EA264FE-7621-458D-8333-9340DDBFC4EE@codeaurora.org>
In-Reply-To: <9EA264FE-7621-458D-8333-9340DDBFC4EE@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/2013 7:05 PM, Kumar Gala wrote:
> On Sep 12, 2013, at 5:47 PM, David Brown wrote:
>
>> On Thu, Sep 12, 2013 at 12:55:36PM -0500, Kumar Gala wrote:
>>> On Sep 12, 2013, at 12:06 PM, Olof Johansson wrote:
>>>> My original request to please use a common prefix for your product
>>>> families stands. Please prefix with msm-*, or if you have to, qcom-*
>>>> instead, since you guys can't seem to make your mind up on standard
>>>> prefixes (msm, apq, etc).
>>> This is silly, I dont see the reason to go with
>>> qcom-apq<SOC>-<BOARD>.dts and than in the future drop qcom- when we
>>> mostly likely shift to a dir structure.  As engineers we are all too
>>> aware of the lack of sanity in marketing names, but its what we have
>>> so we have to live with it.
>> At least what we'd decided a year or two ago was to call _everything_
>> with an msm* prefix.  If marketing comes up with cute prefixes for
>> things, we would basically ignore them.  So, under that, it should be
>> an msm8074-dragonboard.  Admittedly, it might be a little confusing
>> with the name of the product having the apq in it, but as others have
>> pointed out, I think there is less confusing than not having a common
>> prefix on our MSM products.
>>
>> At least so far, there are no chips where apq vs msm actually
>> distinguishes anything.  In fact, a simple "decoder ring" would point
>> out that the 'apq' usually corresponds with the second digit being a
>> zero.  It doesn't help that we've added an 'mpq' prefix as well.
>>
>> I don't really see how to satisfy all of this other than qcom-apq*, or
>> just continue to use msm*.

I think going ahead with what David mentioned  for msm* works if we can 
be consistent or if we want to explicitly mention apq in the file name, 
then
we can rename them to be qcom-msm* or qcom-apq* if people care about the 
differences between them.

>
> I think msm has run out of steam, especially as more SoCs come out of Qualcomm that aren't just targeting phones & tablets.
>
> - k
>


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

