Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbaCSUjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:39:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7923 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbaCSUji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:39:38 -0400
X-IronPort-AV: E=Sophos;i="4.97,688,1389744000"; 
   d="scan'208";a="113045791"
Message-ID: <532A0085.6070104@citrix.com>
Date: Wed, 19 Mar 2014 20:39:33 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <jesse@nicira.com>, <pshelar@nicira.com>, <tgraf@redhat.com>,
        <dev@openvswitch.org>, <pablo@netfilter.org>, <kaber@trash.net>,
        <kadlec@blackhole.kfki.hu>, <edumazet@google.com>,
        <dborkman@redhat.com>, <therbert@google.com>, <jasowang@redhat.com>,
        <fw@strlen.de>, <joe@perches.com>, <horms@verge.net.au>,
        <jiri@resnulli.us>, <mst@redhat.com>, <Paul.Durrant@citrix.com>,
        <JBeulich@suse.com>, <herbert@gondor.apana.org.au>, <mszeredi@suse.cz>,
        <netfilter-devel@vger.kernel.org>, <netfilter@vger.kernel.org>,
        <coreteam@netfilter.org>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395177455-2077-1-git-send-email-zoltan.kiss@citrix.com> <20140319.162459.897793286761249454.davem@davemloft.net>
In-Reply-To: <20140319.162459.897793286761249454.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/14 20:24, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Tue, 18 Mar 2014 21:17:35 +0000
>
>> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
>> orphan them. Also, it doesn't handle errors, so this patch takes care of that
>> as well.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> ---
>>   net/openvswitch/datapath.c |    6 ++++++
>
> Something is seriously wrong with the diffstat generated for
> your submission, please fix this and resubmit.

Sorry, I've turned off diffstat in guilt a while ago, but this patch had 
an old version of it. I've resent it.

Zoli

