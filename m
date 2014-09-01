Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaIAWAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:00:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64487 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaIAWAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:00:07 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5404EC61.9060907@roeck-us.net>
Date: Mon, 01 Sep 2014 15:00:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for Aug 29
References: <20140829150713.50d78c30@canb.auug.org.au> <20140901173521.GA8259@roeck-us.net> <alpine.DEB.2.11.1409011615210.22966@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1409011615210.22966@gentwo.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 02:15 PM, Christoph Lameter wrote:
> On Mon, 1 Sep 2014, Guenter Roeck wrote:
>
>> arch/ia64/sn/kernel/setup.c: In function 'sn_cpu_init':
>> arch/ia64/sn/kernel/setup.c:632:13: error: lvalue required as left operand of assignment
>> make[1]: *** [arch/ia64/sn/kernel/setup.o] Error 1
>> make: *** [arch/ia64/sn/kernel/setup.o] Error 2
>
>
> Subject: ia64: sn_nodepda cannot be assigned to after this_cpu conversion. Use __this_cpu_write.
>
> There must be an explit statement to modify the percpu variable after the conversion of the
> sn_nodpda macro to use this_cpu_read.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
FWIW: Compile-tested-by: Guenter Roeck <linux@roeck-us.net>

Too bad there is no ia64 support in qemu; this could use some "real" testing.

Guenter

