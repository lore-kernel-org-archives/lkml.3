Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3FJQic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:38:32 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:43479 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FJQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:38:30 -0400
MIME-Version: 1.0
In-Reply-To: <1370856152.3252.2.camel@edumazet-glaptop>
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
 <20130610083940.6955.67403.stgit@ladj378.jer.intel.com> <1370856152.3252.2.camel@edumazet-glaptop>
From: Willem de Bruijn <willemb@google.com>
Date: Mon, 10 Jun 2013 12:38:00 -0400
Message-ID: <CA+FuTSchLFTiseMGAVJpBpYyE=8PmDb0huN_YvecfRUiBKHb=g@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 1/6] net: add napi_id and hash
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel <e1000-devel@lists.sourceforge.net>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 5:22 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Mon, 2013-06-10 at 11:39 +0300, Eliezer Tamir wrote:
>> Adds a napi_id and a hashing mechanism to lookup a napi by id.
>> This will be used by subsequent patches to implement low latency
>> Ethernet device polling.
>> Based on a code sample by Eric Dumazet.
>>
>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> ---
>>
>>  include/linux/netdevice.h |   29 ++++++++++++++++++++++
>>  net/core/dev.c            |   59 +++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 88 insertions(+), 0 deletions(-)
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
>

Tested-by: Willem de Bruijn <willemb@google.com>

(per Eliezer's request)
