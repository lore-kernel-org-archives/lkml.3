Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbaDHSK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:10:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:12433 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393AbaDHSKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:10:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,818,1389772800"; 
   d="scan'208";a="516969316"
Message-ID: <53442021.2060608@intel.com>
Date: Tue, 08 Apr 2014 09:13:21 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, nfont@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>	 <533E0B0E.9020909@jp.fujitsu.com> <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 01:27 AM, Li Zhong wrote:
> If Dave and others don't have further objections, it seems this small
> userspace incompatibility could be accepted by most of us, and I don't
> need to make a version 2. 

Let me ask another question then.  What are the units of
phys_index/end_phys_index?  How do we expose those units to userspace?
