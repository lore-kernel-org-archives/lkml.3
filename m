Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaJUFNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:13:09 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:43273 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaJUFMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:12:54 -0400
MIME-Version: 1.0
In-Reply-To: <1413867285.5498.2.camel@concordia>
References: <1412920428-29263-1-git-send-email-bobby.prani@gmail.com>
	<20141021043846.8E5D4140092@ozlabs.org>
	<CAHj3AVnj4Etu71egZ30a-KHYdLHjd2S4J8TY0mjHX_Q+BLvLMA@mail.gmail.com>
	<1413867285.5498.2.camel@concordia>
Date: Tue, 21 Oct 2014 09:12:53 +0400
Message-ID: <CAHj3AV=Zqo=gOkQk2dRZS2S3CQO774QiwoOVkQxAOYYtWmpAvA@mail.gmail.com>
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

I don't see any problems with it

On 10/21/14, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Tue, 2014-10-21 at 08:52 +0400, Denis Kirjanov wrote:
>> We have a test suite under samples/bpf/
>
> Thanks.
>
> I looked under tools/testing/selftests, could it move in there?
>
> cheers
>
>
>


-- 
Regards,
Denis
