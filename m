Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3KFTcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:32:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab3KFTcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:32:16 -0500
Message-ID: <527A9903.3050700@redhat.com>
Date: Wed, 06 Nov 2013 20:31:15 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andrey Vagin <avagin@openvz.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@plumgrid.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org.#.3.12
Subject: Re: [PATCH] net: don't forget to free sk_filter
References: <1383753106-26978-1-git-send-email-avagin@openvz.org>  <527A9638.4020404@redhat.com> <1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 08:28 PM, Eric Dumazet wrote:
> On Wed, 2013-11-06 at 20:19 +0100, Daniel Borkmann wrote:
>
>> When you send v2 with Alexei's feedback, please also be more specific
>> in your subject like "net: x86: bpf: don't forget to free sk_filter"
>> or the like. Also it's enough to say 'This memory leak was introduced
>> by commit d45ed4a4e3 ("net: fix unsafe set_memory_rw from softirq")'
>> instead of copying the whole log. Anyways, for v2 with feedback included
>> then:
>
> Actually, the new way [1] of doing this would be to use the 'Fixes:' tag
> as in :
>
> Fixes: <12 digits SHA1> ("net: fix unsafe set_memory_rw from softirq")
>
> [1] As discussed at last Kernel Summit
>
> Example in
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6920a1bd037374a632d585de127b6f945199dcb8

Cool, good to know, that's even better!
