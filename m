Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbaDHSXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:23:17 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59677 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820AbaDHSXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:23:14 -0400
Message-ID: <53443E8C.4070906@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2014 13:23:08 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com> <533E0B0E.9020909@jp.fujitsu.com> <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com> <53442021.2060608@intel.com>
In-Reply-To: <53442021.2060608@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040818-5806-0000-0000-0000249327A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 11:13 AM, Dave Hansen wrote:
> On 04/08/2014 01:27 AM, Li Zhong wrote:
>> If Dave and others don't have further objections, it seems this small
>> userspace incompatibility could be accepted by most of us, and I don't
>> need to make a version 2. 
> 
> Let me ask another question then.  What are the units of
> phys_index/end_phys_index?  How do we expose those units to userspace?
>

The documentation for these files just states that the files contain
the first and last section id of memory in the memory block for
phys_index and end_phys_index respectively.

I'm not sure the values have ever been units of anything, at least not
that I remember.

-Nathan
 

