Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaIJC4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:56:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:44463 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaIJC4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:56:38 -0400
Message-ID: <540FBDDC.5040602@huawei.com>
Date: Wed, 10 Sep 2014 10:56:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org PATCH] Li Zefan is now the 3.4 stable maintainer
References: <20140826230858.GA29970@kroah.com> <20140827045938.GA28282@roeck-us.net> <540813A5.7020704@huawei.com> <20140904183953.GA28599@roeck-us.net> <54096C8D.8000008@huawei.com> <5409C19C.4030901@roeck-us.net>
In-Reply-To: <5409C19C.4030901@roeck-us.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.540FBDE3.0023,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 0ca596a5fc86cfff7becc740545ba4ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/5 21:58, Guenter Roeck wrote:
> On 09/05/2014 12:55 AM, Li Zefan wrote:
>>>>> Li,
>>>>>
>>>>> it would be great if you can send me information about your -stable queue,
>>>>> ie how you maintain it and where it is located. This will enable me to
>>>>> continue testing the stable queue for the 3.4 kernel.
>>>>>
>>>>
>>>> Thanks for testing LTS kernels!
>>>>
>>>> This is my 3.4.y git tree:
>>>>
>>>> https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y.git/
>>>>
>>>> And this is the patch queue:
>>>>
>>>> https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y-queue.git/
>>>>
>>>> I use quilt. When I've added some patches to 3.4.y, I'll update this
>>>> queue. The patches and series file are under /patches. Currently there's
>>>> already a patch in the queue.
>>>>
>>>> When I release a new version, I'll clean up the queue by removing all
>>>> the files under /patches.
>>>>
>>>> Hope this is all the information you need. Please tell me if you need
>>>> me to slightly adjust my workflow so it's easier for you.
>>>
>>> It almost works.
>>>
>>> Problem is that the pending patch got converted to use <cr><lf> instead of
>>> just <lf> as common in Linux. When I try to apply it with "git quiltimport",
>>> it bails out with "trailing whitespace" errors. "git am" with the individual
>>> patch works fine for some reason, though.
>>>
>>> I can try to find a workaround, but it would be better to have the file in
>>> linux file format to start with. Would that be possible ?
>>>
>>
>> Yeah, I've fixed it. I'll run dos2unix for every patch file.
>>
> 
> Yes, it now works. Wonder how it comes that the patch in Greg's patch tree
> didn't have the problem. Any idea ?
> 

I saved the patch from my email client, and turned out the lines ended
with CRLF.

