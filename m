Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaAWS4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:56:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:17542 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbaAWSz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:55:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,707,1384329600"; 
   d="scan'208";a="443630699"
Message-ID: <52E165B7.6020506@intel.com>
Date: Thu, 23 Jan 2014 10:55:51 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: kernel@gentoo.org, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <52DEA270.60803@gmx.de>
In-Reply-To: <52DEA270.60803@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 08:38 AM, Toralf Förster wrote:
> Jan 21 17:18:57 n22 kernel: INFO: rcu_sched self-detected stall on CPU { 2}  (t=60001 jiffies g=18494 c=18493 q=183951)
> Jan 21 17:18:57 n22 kernel: sending NMI to all CPUs:
> Jan 21 17:18:57 n22 kernel: NMI backtrace for cpu 2
> Jan 21 17:18:57 n22 kernel: CPU: 2 PID: 6779 Comm: qemu-system-x86 Not tainted 3.13.0 #3
> Jan 21 17:18:57 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
> Jan 21 17:18:57 n22 kernel: task: e921c370 ti: e5f36000 task.ti: e5f36000

I'm seeing a very similar hang with an ubuntu guest and a custom kernel.
 I'm on commit 0dc3fd0249a, and it's 100% reproducible every time I run KVM.

Cc-ing a few more folks...
