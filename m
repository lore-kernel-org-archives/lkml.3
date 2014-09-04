Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaIDBpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:45:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:17706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbaIDBpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:45:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="381143787"
Date: Thu, 4 Sep 2014 09:46:39 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, hpa@zytor.com
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linn Crosetto <linn@hp.com>, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140904014639.GA4688@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
 <20140808224057.GA9288@oranje.fc.hp.com>
 <20140815030042.GA14928@kernel>
 <20140815060755.GA24362@pd.tnic>
 <53FACA7F.5090809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FACA7F.5090809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Ingo, Peter,
On Mon, Aug 25, 2014 at 01:32:47PM +0800, Wanpeng Li wrote:
>
>于 14-8-15 下午2:07, Borislav Petkov 写道:
>>On Fri, Aug 15, 2014 at 11:00:42AM +0800, Wanpeng Li wrote:
>>>Is it ok for you to apply this patch or still need update?
>>Just be patient: we have the merge window still open and after that
>>kernel summit coming up first.
>
>Thanks for pointing out.
>
>Regards,
>Wanpeng Li
>
>>
