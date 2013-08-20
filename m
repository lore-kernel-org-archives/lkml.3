Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3HTQn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:43:59 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:42831 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3HTQn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:43:56 -0400
X-AuditID: cbfec37b-b7f306d0000047de-43-52139ccac189
Message-id: <52139CC8.3000708@samsung.com>
Date: Tue, 20 Aug 2013 10:43:52 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 00/34] 3.4.59-stable review
References: <20130818203259.653403173@linuxfoundation.org>
 <52125DA9.3090601@samsung.com> <20130819193538.GB24897@kroah.com>
 <201308192214.54917.s.L-H@gmx.de> <52129AC3.5020402@samsung.com>
 <20130819223037.GA3838@kroah.com>
 <1DC40B07CD6EC041A66726C271A73AE61AA6B9CC@IRSMSX102.ger.corp.intel.com>
 <20130820152401.GA5211@kroah.com>
 <alpine.LNX.2.00.1308200851190.991@eggly.anvils>
 <20130820160355.GA9427@kroah.com>
In-reply-to: <20130820160355.GA9427@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX93Tc4SDDO5NYLdoXryezeLppz4W
	i0crZrFbXN41h83i0ZOLbBZffzpYLNj4iNGB3WPnrLvsHh8+xnks2FTqsXjPSyaP/XPXsHt8
	3iQXwBbFZZOSmpNZllqkb5fAldH0/zlTwUWuiktXHrE3MK7n6GLk5JAQMJHouXicDcIWk7hw
	bz2YLSSwjFFi5cuwLkYuILuXSeLz8yOsEImNjBLLOgpAbF4BLYlPP3+ANbAIqEr8XfWVBcRm
	E1CX+Px6BztEvZxE05LVzF2MHByiAhESR5drQrQKSvyYfA+sXETAWKL/7Cx2kF3MAoeZJC68
	mA2WEAaa//XPKzaII1YxSzzrmgE2lFNAT+Lym8mMIDazgLXEyknboGx5ic1r3jJDLFaW+HP5
	FBPIYgkBRYntq60mMIrMQrJ7FpLuWUi6FzAyr2IUKy1OLihOSk+tMNIrTswtLs1L10vOz93E
	CIml6h2Md7/aHGIU4GBU4uHdUCgcJMSaWFZcmXuIUYKDWUmEd1sGUIg3JbGyKrUoP76oNCe1
	+BAjEwenVANj9rw/iis0/YNZmubopAZdMH/H8vq5S1zJaW7r4E3tfy1fOQVeS30QXNvW/V+/
	2P/5ClWFi3vvRbpsyrbrXv7Ruufql27Bym3skkrHVm6ZvFMk/tdWQxlXZ0cN6QP3M8/MfxLx
	niWl/r6en4XxiiRJrS1LbPlnHz7sbNztkNUut+j0opLX+1cosRRnJBpqMRcVJwIA7VNa5IMC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:03 AM, Greg Kroah-Hartman wrote:
> On Tue, Aug 20, 2013 at 08:53:24AM -0700, Hugh Dickins wrote:
>> On Tue, 20 Aug 2013, Greg Kroah-Hartman wrote:
>>> On Tue, Aug 20, 2013 at 07:36:00AM +0000, Berg, Johannes wrote:
>>>>>> [ 26/34] genetlink: fix family dump race
>>>>>
>>>>> Johannes, another strike against this patch :(
>>>>>
>>>>> Any chance on fixing it upstream and me sucking that fix in?
>>>>
>>>> Yeah, I'm trying to get that, but it's not clear to me how to fix it.
>>>> Where did you apply it? It was going to need some fixes but when the
>>>> first objection was raised I figured you were going to drop it for now
>>>> completely? Sorry for the mess :-(
>>>
>>> You're right, I'll drop this for 3.4, it doesn't make sense there.
>>
>> And you'll drop it from 3.0 and 3.10 also, I hope?
>
> It wasn't in 3.0, was it?  Oh crap, it was...
>
> 3.10, I'd rather have the "real" fix that ends up resolving the issue in
> Linus's tree also, instead of just dropping it.
>
> Especially as I just did the releases...
>

3.10 worked fine with no issues with this fix. I couldn't test 3.0 on 
this system because 3.4 is the minimum for my test system.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
