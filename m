Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3JKWHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:07:04 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62553 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3JKWHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:07:02 -0400
Message-ID: <52587681.8090703@gmail.com>
Date: Fri, 11 Oct 2013 15:06:57 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] UPROBES: Remove useless __weak attribute
References: <20131009120809.GN1615@linux-mips.org> <20131011005128.GA2199@linux.vnet.ibm.com> <20131011122407.GO1615@linux-mips.org>
In-Reply-To: <20131011122407.GO1615@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 05:24 AM, Ralf Baechle wrote:
> On Fri, Oct 11, 2013 at 06:21:28AM +0530, Srikar Dronamraju wrote:
>
>> Will be nice to have another arch(mips) support for uprobes.
>
> It's basically ready to be merged - but it's triggering issues elsewhere
> in the kernel which I have to resolve first.
>
> The short version is that the memory special mapping created by uprobe
> with VM_EXEC but not VM_READ permissions is not working but it's working
> if I add VM_READ.  That should not be necessary so something deep down
> in the guts of arch/mips is wrong.
>

Weird, I have a testcase that explicitly tests VM_EXEC and !VM_READ that 
works.

Do you have more information about the failure, I can look at it in the 
simulator and see where it goes wrong.

Thanks,
David Daney

