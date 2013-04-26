Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab3DZDTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 23:19:54 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:44185 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384Ab3DZDTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 23:19:53 -0400
Message-ID: <5179F241.2040301@linux.vnet.ibm.com>
Date: Fri, 26 Apr 2013 11:19:29 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Chen Gang <gang.chen@asianux.com>, Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <20130425062539.GA421@iris.ozlabs.ibm.com>
In-Reply-To: <20130425062539.GA421@iris.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042603-2674-0000-0000-000008BDA818
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/4/25 14:25, Paul Mackerras 写道:
> On Thu, Apr 25, 2013 at 12:05:54PM +0800, Mike Qiu wrote:
>> This has block my work now
>> So I hope you can take a look ASAP
>> Thanks
>> :)
>>
>> Mike
> As a quick fix, turn on CONFIG_KVM_BOOK3S_64_HV.  That will eliminate
> the immediate problem.
Thanks
got it, I will have a try.
> Paul.
>

