Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3JBDLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 23:11:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:58702 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3JBDLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 23:11:18 -0400
X-Spam-Score: -100.9
Message-ID: <524B8E97.1030707@asianux.com>
Date: Wed, 02 Oct 2013 11:10:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, toshi.kani@hp.com,
        rafael.j.wysocki@intel.com, isimatu.yasuaki@jp.fujitsu.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] about calling debug_hotplug_cpu() which enabled by 'allmodconfig'
 for a x86_64 dual core laptop.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Under my x86_64 dual core laptop, I build kernel next-20130927 with
'allmodconfig', and install it, the machine can not start. Related
information is:

  after call debug_hotplug_cpu(), output "cpu 0 is offline" .... and then "Failed to execute /init".

After remove "_debug_hotplug_cpu(0, 0);", can pass the issue (but will
fail in another place). I guess, the reason is my laptop cpu is not
'hotplug', but have to call debug_hotplug_cpu() with allmodconfig.


I will continue analyzing, welcome any additional suggestions or
completions.

Thanks.
-- 
Chen Gang
