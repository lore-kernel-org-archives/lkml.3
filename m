Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3FJQjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:39:08 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64160 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3FJQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <1370874744.3252.5.camel@edumazet-glaptop>
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
 <20130610084010.6955.14413.stgit@ladj378.jer.intel.com> <1370874744.3252.5.camel@edumazet-glaptop>
From: Willem de Bruijn <willemb@google.com>
Date: Mon, 10 Jun 2013 12:38:35 -0400
Message-ID: <CA+FuTScdGoeocndgGM9=rE+1BAa3urxHWXSpimJ7o7726NhF9g@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 4/6] tcp: add low latency socket poll support.
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

On Mon, Jun 10, 2013 at 10:32 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Mon, 2013-06-10 at 11:40 +0300, Eliezer Tamir wrote:
>> Adds low latency socket poll support for TCP.
>> In tcp_v[46]_rcv() add a call to sk_mark_ll() to copy the napi_id
>> from the skb to the sk.
>> In tcp_recvmsg(), when there is no data in the socket we busy-poll.
>> This is a good example of how to add busy-poll support to more protocols.
>>
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> ---
>
> Acked-by: Eric Dumazet <edumazet@google.com>
>

Tested-by: Willem de Bruijn <willemb@google.com>

(per Eliezer's request)
