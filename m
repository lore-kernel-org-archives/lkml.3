Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaBJMky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:40:54 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:47747 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaBJMks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:40:48 -0500
Message-ID: <52F8C8CB.1040204@gmail.com>
Date: Mon, 10 Feb 2014 13:40:43 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>, Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>, Dave Jones <davej@redhat.com>,
        kernel@lists.fedoraproject.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 0 PID: 2243 at mm/slub.c:1007 deactivate_slab+0x4e0/0x590()
References: <52F832C0.9070702@gmail.com> <alpine.DEB.2.02.1402100212280.30650@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402100212280.30650@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.02.2014 11:14, David Rientjes wrote:
> On Mon, 10 Feb 2014, poma wrote:
> 
>> [   83.530421] WARNING: CPU: 0 PID: 2243 at mm/slub.c:1007
>> deactivate_slab+0x4e0/0x590()
> 
> Yeah, you'll need the patch from the http://marc.info/?t=139145791300002 
> thread.  It's in the -mm tree as
> mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch and I'm 
> hoping it will go into 3.14-rc3, several people have been complaining 
> about it.
> 

All right!
Thanks for the prompt reply!

http://marc.info/?l=linux-kernel&m=139145999324131&q=raw
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/patch/mm/slub.c?id=aee03fe7a7c8c71540613b6918f766556bda40a7

Patched & tested with 3.14.0-0.rc1.git5.5.fc21.1.x86_64,
PASSED.


poma

