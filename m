Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaJUEw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:52:29 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:52693 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaJUEw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <20141021043846.8E5D4140092@ozlabs.org>
References: <1412920428-29263-1-git-send-email-bobby.prani@gmail.com>
	<20141021043846.8E5D4140092@ozlabs.org>
Date: Tue, 21 Oct 2014 08:52:27 +0400
Message-ID: <CAHj3AVnj4Etu71egZ30a-KHYdLHjd2S4J8TY0mjHX_Q+BLvLMA@mail.gmail.com>
Subject: Re: powerpc: Wire up sys_bpf() syscall
From: Denis Kirjanov <kirjanov@gmail.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a test suite under samples/bpf/


On 10/21/14, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Fri, 2014-10-10 at 05:53:45 UTC, Pranith Kumar wrote:
>> This patch wires up the new syscall sys_bpf() on powerpc.
>
> Is there a test suite we can run to verify it works?
>
> cheers
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


-- 
Regards,
Denis
