Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaHYFdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 01:33:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37232 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaHYFdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 01:33:17 -0400
Message-ID: <53FACA7F.5090809@gmail.com>
Date: Mon, 25 Aug 2014 13:32:47 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Wanpeng Li <wanpeng.li@linux.intel.com>
CC: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
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
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com> <20140808224057.GA9288@oranje.fc.hp.com> <20140815030042.GA14928@kernel> <20140815060755.GA24362@pd.tnic>
In-Reply-To: <20140815060755.GA24362@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 14-8-15 下午2:07, Borislav Petkov 写道:
> On Fri, Aug 15, 2014 at 11:00:42AM +0800, Wanpeng Li wrote:
>> Is it ok for you to apply this patch or still need update?
> Just be patient: we have the merge window still open and after that
> kernel summit coming up first.

Thanks for pointing out.

Regards,
Wanpeng Li

>

