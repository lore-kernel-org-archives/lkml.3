Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750933Ab3DYEGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 00:06:10 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42010 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab3DYEGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 00:06:08 -0400
Message-ID: <5178ABA2.4030109@linux.vnet.ibm.com>
Date: Thu, 25 Apr 2013 12:05:54 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com>
In-Reply-To: <5178816D.3000309@asianux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042503-1618-0000-0000-000003C33242
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/4/25 9:05, Chen Gang 写道:
> On 2013年04月24日 20:47, Mike wrote:
>> 在 2013-04-24三的 20:37 +1000，Michael Neuling写道：
>>>> Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
>>>>
>>>>>> 于 2013/4/24 16:31, Michael Ellerman 写道:
>>>>>>>> On Wed, Apr 24, 2013 at 04:22:53PM +0800, Mike Qiu wrote:
>>>>>>>>>> Hi all
>>>>>>>>>>
>>>>>>>>>> I get an error message when I compile the source code in Power7 platform
>>>>>>>>>> use the newest upstream kernel.
>>>>>>>> Hi Mike,
>>>>>>>>
>>>>>>>> It depends on what your .config is. What defconfig are you building?
>>>>>> I just copy the config file from /boot/config.* to .config and use make
>>>>>> menuconfig
>>>>>> change nothing by manually, then save.
>>>> Can you post the resulting config here?
>>>>
>>>> Do you have commit in your tree?
>>>>    commit 087aa036eb79f24b856893190359ba812b460f45
>>>>    Author: Chen Gang <gang.chen@asianux.com>
>>>>    powerpc: make additional room in exception vector area
>>>>
>> Sure, that commit certainly in my git tree. And I just try to remove the
>> code and re-git clone the source code from upstream, this problem still
>> happen.
>> I will post the config file as the attachment
>> :)
>>
>> Thanks
> I will try, and plan to get a result within this week (2013-04-28)
>
> Thanks.
Hi
This has block my work now
So I hope you can take a look ASAP
Thanks
:)

Mike

