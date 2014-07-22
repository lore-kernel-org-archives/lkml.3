Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaGVJ33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:29:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:62386 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbaGVJ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:29:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,709,1400050800"; 
   d="scan'208";a="565362189"
Date: Tue, 22 Jul 2014 17:30:23 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH v2] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140722093023.GA6841@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1406016292-55968-1-git-send-email-wanpeng.li@linux.intel.com>
 <20140722084641.GA5730@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722084641.GA5730@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:46:41AM -0400, Chen, Gong wrote:
>On Tue, Jul 22, 2014 at 04:04:52PM +0800, Wanpeng Li wrote:
>> Subject: [PATCH v2] x86, hotplug: fix llc shared map unreleased during cpu
>>  hotplug
>
>See this link:
>https://lkml.org/lkml/2014/7/17/78

Interesting, thanks for your pointing out.

Regards,
Wanpeng Li 

