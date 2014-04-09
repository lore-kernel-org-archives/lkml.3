Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbaDIPv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:51:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:18102 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898AbaDIPv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:51:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,826,1389772800"; 
   d="scan'208";a="490058601"
Message-ID: <53456C12.7000905@intel.com>
Date: Wed, 09 Apr 2014 08:49:38 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>	 <533E0B0E.9020909@jp.fujitsu.com>	 <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com>	 <53442021.2060608@intel.com> <53443E8C.4070906@linux.vnet.ibm.com>	 <53445245.3020400@intel.com> <1397035220.25199.39.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1397035220.25199.39.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 02:20 AM, Li Zhong wrote:
> Or do you mean we don't need to expose any information related to
> SECTION to userspace? 

Right, we don't need to expose sections themselves to userspace.  Do we?
