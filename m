Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3COROI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:14:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46649 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3COROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:14:05 -0400
Message-ID: <514356D9.2020708@wwwdotorg.org>
Date: Fri, 15 Mar 2013 11:14:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 3/3] serial: tegra: Convert to devm_ioremap_resource()
References: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org> <1359627939-2685-3-git-send-email-sachin.kamat@linaro.org> <510AA318.5060208@wwwdotorg.org> <CAK9yfHzSq8SpKXQYtFd1Ds+N-AoH+H+BdWrPsPT=OwSPdst1WA@mail.gmail.com> <510B436A.20808@wwwdotorg.org> <CAK9yfHzJvOC_wvsxvapi7rATq97QX-6exOyqjNTSguhh3RLVvQ@mail.gmail.com> <510BF8EC.7090801@wwwdotorg.org> <CAK9yfHx1jLPpdCHAb-pC-C7wt81gQLgTnpuvK+0aNKkhuXHcDQ@mail.gmail.com> <20130315163803.GA29113@kroah.com>
In-Reply-To: <20130315163803.GA29113@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 10:38 AM, gregkh@linuxfoundation.org wrote:
> On Sat, Feb 02, 2013 at 10:22:16AM +0530, Sachin Kamat wrote:
>>
>>
>> On Friday, 1 February 2013, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 02/01/2013 02:49 AM, Sachin Kamat wrote:
>>>> On 1 February 2013 09:54, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>>>>
>>>>>> The entire series is merged in Greg's driver-core tree [1] and I
>>>>>> presume all other associated patches would also be picked up by him.
>>>>>> Isn't it Greg?
>>>>>>
>>>>>> [1] git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
>>>>>
>>>>> The Tegra serial driver went through Greg's TTY tree. I assume that goes
>>>>> direct to Linus not through driver-core.git first.
>>>>
>>>> Right. But AFAIK for this specific change he has carried the patches
>>>> in the device-core tree irrespective of the subsystem.
>>>
>>> Yes, but the Tegra serial driver is new for 3.9, and hence does not yet
>>> exist in driver-core.git.
>>>
>>
>> Oh ok. Then probably we can have this patch only after 3.9-rc1 is out.
> 
> Yes, Stephen can take this patch now.

There's no need for me to take the patch I think; now that 3.9-rc1 is
out, the serial and driver core trees all have whatever dependencies
this series needed, so any patches can go through their usual trees, I
think... (Sorry, the context of this discussion was little while ago).
