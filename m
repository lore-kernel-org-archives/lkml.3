Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941AbaDIQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:16:59 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34880 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933869AbaDIQQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:16:57 -0400
Message-ID: <53457271.7050605@linux.vnet.ibm.com>
Date: Wed, 09 Apr 2014 11:16:49 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Li Zhong <zhong@linux.vnet.ibm.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com> <533E0B0E.9020909@jp.fujitsu.com> <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com> <53442021.2060608@intel.com> <53443E8C.4070906@linux.vnet.ibm.com> <53445245.3020400@intel.com> <1397035220.25199.39.camel@ThinkPad-T5421.cn.ibm.com> <53456C12.7000905@intel.com>
In-Reply-To: <53456C12.7000905@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040916-5806-0000-0000-000024957C25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 10:49 AM, Dave Hansen wrote:
> On 04/09/2014 02:20 AM, Li Zhong wrote:
>> Or do you mean we don't need to expose any information related to
>> SECTION to userspace? 
> 
> Right, we don't need to expose sections themselves to userspace.  Do we?
>

No. the layout in sysfs is based in block_size_bytes so I do not see any
need to expose sections to userspace.

-Nathan
 

