Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab3DZB6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 21:58:31 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33992 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3DZB6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:58:30 -0400
Message-ID: <5179DF37.8020407@linux.vnet.ibm.com>
Date: Fri, 26 Apr 2013 09:58:15 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Paul Mackerras <paulus@samba.org>, Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <20130425062539.GA421@iris.ozlabs.ibm.com> <51791076.9040405@asianux.com>
In-Reply-To: <51791076.9040405@asianux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042601-0260-0000-0000-000002DE507C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/4/25 19:16, Chen Gang 写道:
> On 2013年04月25日 14:25, Paul Mackerras wrote:
>> On Thu, Apr 25, 2013 at 12:05:54PM +0800, Mike Qiu wrote:
>>>> This has block my work now
>>>> So I hope you can take a look ASAP
>>>> Thanks
>>>> :)
>>>>
>>>> Mike
>> As a quick fix, turn on CONFIG_KVM_BOOK3S_64_HV.  That will eliminate
>> the immediate problem.
> Yes, just as my original reply to Mike to bypass it, but get no reply, I
> guess he has to face the CONFIG_KVM_BOOK3S_64_PR.
>
> Now, I am just fixing it, when I finish one patch, please help check.
Actually, I have compile pass by your patch, but I see Micheal Neuling's 
reply,
I just stop to do that, and wait for you new patch :)

Now I will use your V2 patch to build

Thanks

Mike
> Thanks.
>

