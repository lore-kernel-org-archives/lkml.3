Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaANGEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:04:23 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35540 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaANGEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:04:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140113.211619.613683326137425186.davem@davemloft.net>
References: <20140114004509.27138.50345.stgit@viggo.jf.intel.com>
	<20140114004637.27138.50365.stgit@viggo.jf.intel.com>
	<20140113.211619.613683326137425186.davem@davemloft.net>
Date: Mon, 13 Jan 2014 22:04:20 -0800
Message-ID: <CAPcyv4ha6gt+xB5K02YOuOcKsWH6GCKvhsjs+ZSTqzAtqE5oFA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] net_dma: revert 'copied_early'
From: Dan Williams <dan.j.williams@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Netdev <netdev@vger.kernel.org>, saidi@engin.umich.edu,
        James Morris <jmorris@namei.org>, edumazet@google.com,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Dave Jones <davej@redhat.com>,
        Neal Cardwell <ncardwell@google.com>,
        Patrick McHardy <kaber@trash.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 9:16 PM, David Miller <davem@davemloft.net> wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Mon, 13 Jan 2014 16:47:14 -0800
>
>> Now that tcp_dma_try_early_copy() is gone nothing ever sets
>> copied_early.
>>
>> Also reverts "53240c208776 tcp: Fix possible double-ack w/ user dma"
>> since it is no longer necessary.
>>
>> Cc: Ali Saidi <saidi@engin.umich.edu>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Patrick McHardy <kaber@trash.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>> Cc: Neal Cardwell <ncardwell@google.com>
>> Reported-by: Dave Jones <davej@redhat.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Acked-by: David S. Miller <davem@davemloft.net>

Thank you sir.
