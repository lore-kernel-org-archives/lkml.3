Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaKZR47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:56:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaKZR45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:56:57 -0500
Message-ID: <54761424.8060203@redhat.com>
Date: Wed, 26 Nov 2014 18:55:48 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
References: <CAADnVQK8mn4ZHwbhBArosEw3Bmsc5vJfOzAeRE3R_1S7dbNfkg@mail.gmail.com> <1417021108.19695.5.camel@perches.com>
In-Reply-To: <1417021108.19695.5.camel@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 05:58 PM, Joe Perches wrote:
...
>> imo existing code is fine and I don't think the time spent
>> reviewing such changes is worth it when there is no
>> improvement in readability.

+1

> Is there any value in reordering these tests for frequency
> or maybe using | instead of || to avoid multiple jumps?

No, it's not a fast-path.
