Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3D0Jd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 05:33:56 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56231 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3D0Jdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 05:33:55 -0400
X-Spam-Score: -100.8
Message-ID: <517B9B53.2030502@asianux.com>
Date: Sat, 27 Apr 2013 17:33:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] PowerPC: kernel: compiling issue, make additional
 room in exception vector area
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <20130425062539.GA421@iris.ozlabs.ibm.com> <517918AB.4020508@asianux.com> <30269.1366931768@ale.ozlabs.ibm.com> <5179D302.9060203@asianux.com> <5179D5D8.8080102@asianux.com> <5179DA23.8000407@asianux.com> <5179E056.2000709@linux.vnet.ibm.com> <5179E11F.8010007@asianux.com> <5179EFB6.3090602@linux.vnet.ibm.com> <5179F39C.5020408@asianux.com> <5179F7B8.5010701@asianux.com> <5179FA8E.9090501@linux.vnet.ibm.com> <517B9A4D.1020502@gmail.com> <517B9B2B.30007@linux.vnet.ibm.com>
In-Reply-To: <517B9B2B.30007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月27日 17:32, Mike Qiu wrote:
>>>
>> I think the diff v2 is correct, but is not the best one for this issue.
>>
>> I prefer the Paul's patch for this issue which has better performance
>>
>> :-)
> yes, I use your patch and it can work, also Paul's patch can work too.

Good news.

Bye !

:-)

-- 
Chen Gang

Asianux Corporation
