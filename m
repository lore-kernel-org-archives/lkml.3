Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148Ab3GSSp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:45:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53074 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761131Ab3GSSpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:45:24 -0400
Message-ID: <51E98941.2090306@wwwdotorg.org>
Date: Fri, 19 Jul 2013 12:45:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: Guenter Roeck <linux@roeck-us.net>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, wni@nvidia.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, l.stach@pengutronix.de
Subject: Re: [lm-sensors] [RESEND PATCH V1 0/9] thermal: introduce DT thermal
 zone build
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com> <20130717220942.GB990@roeck-us.net> <51E7F341.8020508@ti.com> <20130718211154.GB4110@roeck-us.net> <51E9413C.2080007@ti.com>
In-Reply-To: <51E9413C.2080007@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 07:38 AM, Eduardo Valentin wrote:
> On 18-07-2013 17:11, Guenter Roeck wrote:
>> On Thu, Jul 18, 2013 at 09:53:05AM -0400, Eduardo Valentin
>> wrote:
>>> Hello Guenter,
>>> 
>>> On 17-07-2013 18:09, Guenter Roeck wrote:
>>>> On Wed, Jul 17, 2013 at 11:17:19AM -0400, Eduardo Valentin
>>>> wrote:
>>>>> Hello all,
>>>>> 
>>>>> As you noticed, I am working in a way to represent thermal
>>>>> data using device tree [1]. Essentially, this should be a
>>>>> way to say what to do with a sensor and how to associate
>>>>> (cooling) actions with it.
>>>>> 
>>>> Seems to me that goes way beyond the supposed scope of
>>>> devicetree data. Devicetree data is supposed to describe
>>>> hardware, not its configuration or use. This is clearly a use
>>>> case.
>>> 
>>> Thanks for rising your voice here. It is important to know what
>>> hwmon ppl think about this.
>>> 
>> Sorry, I don't know what ppl stands for.
>> 
>>>> 
>>>> Guenter
>>> 
>>> As your answers to the series are giving same argument, I chose
>>> to answer on patch 0. I would be happier if you could elaborate
>>> a bit more on your concern, specially if you take hwmon cap
>>> here, and give your view with that perspective.
>>> 
>>> I also considered that this work could be abusing of DT
>>> purposes. But let me explain why I still think it makes sense
>>> to have it.
>>> 
>> Ultimately, you are making my point here. If you considered it,
>> did you ask devicetree experts for an opinion ? Did you discuss
>> the subject on the devicetree-discuss mailing list ? If so, what
>> was the result ?
> 
> Although I have asked, I didn't get any feedback. 
> https://lkml.org/lkml/2013/4/11/760
> 
> But now I am requesting feedback in a formal (patch) way.
> 
> Consider this patch series as official request for (devicetree
> experts and everyone involved) opinions.

I might suggest (a) sending the email "To" the DT maintainer, rather
than just CC'ing him, (b) perhaps start a new thread just to present
the proposed DT binding, and get feedback on that. A thread with a new
subject like "[RFC] DT binding for thermal zones" might get more
attention than a patch submission; the subject line of this patch
doesn't stand much (since it implies to me it's more about build
issues than DT bindings even though it does mention DT).
