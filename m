Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaHOC7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 22:59:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:41730 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbaHOC7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 22:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,867,1400050800"; 
   d="scan'208";a="558849999"
Date: Fri, 15 Aug 2014 11:00:42 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: hpa@zytor.com
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linn Crosetto <linn@hp.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140815030042.GA14928@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
 <20140808224057.GA9288@oranje.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808224057.GA9288@oranje.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
On Fri, Aug 08, 2014 at 04:40:57PM -0600, Linn Crosetto wrote:
[...]
>
>Tested with a CPU hotplug stress test, run on a large system with 240 CPUs.
>Thanks.
>
>Tested-by: Linn Crosetto <linn@hp.com>

Is it ok for you to apply this patch or still need update?

Regards,
Wanpeng Li 
