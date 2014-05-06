Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687AbaEFJvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:51:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40919 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934559AbaEFJvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:51:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,996,1389744000"; 
   d="scan'208";a="128148999"
Message-ID: <5368B088.8040206@citrix.com>
Date: Tue, 6 May 2014 10:51:04 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: 3.15-rc3: boot of a xen PV guest fails when using a guest kernel
 with CONFIG_DEBUG_SLAB=y
References: <169388657.20140502230132@eikelenboom.it>
In-Reply-To: <169388657.20140502230132@eikelenboom.it>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/14 22:01, Sander Eikelenboom wrote:
> Hi,
> 
> On a machine running Xen-Unstable, i just tried running a 3.15-rc3 kernel with 
> CONFIG_DEBUG_SLAB=y
> 
> [    0.748297] Kernel panic - not syncing: Out of memory and no killable processes...
> [    0.748297]
> [    0.748305] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc3-20140502-nbdebug12-slabdb+ #1
> [    0.748310]  00000000002040d0 ffff88000ee9fa48 ffffffff81b8da66 ffff88000ee9c010
> [    0.748317]  ffffffff81f5a8a0 ffff88000ee9fac8 ffffffff81b89bfb 0000000000000000
> [    0.748325]  ffffffff00000008 ffff88000ee9fad8 ffff88000ee9fa78 ffffffff811952fa
> [    0.748332] Call Trace:
> [    0.748336]  [<ffffffff81b8da66>] dump_stack+0x46/0x58
> [    0.748340]  [<ffffffff81b89bfb>] panic+0xd2/0x207
> [    0.748345]  [<ffffffff811952fa>] ? out_of_memory+0x39a/0x5a0
> [    0.748350]  [<ffffffff811954fe>] out_of_memory+0x59e/0x5a0


Your guest is out of memory.  Give it some more?

David

