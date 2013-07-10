Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3GJOA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:00:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:43169 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3GJOAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:00:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1036,1363158000"; 
   d="scan'208";a="329313791"
Message-ID: <51DD6910.80207@linux.intel.com>
Date: Wed, 10 Jul 2013 17:00:48 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, e1000-devel@lists.sourceforge.net,
        Eilon Greenstein <eilong@broadcom.com>,
        Amir Vadai <amirv@mellanox.com>, Eric Dumazet <erdnetdev@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH net-next v2 1/3] net: rename include/net/ll_poll.h to
 include/net/busy_poll.h
References: <20130710121349.12906.85078.stgit@ladj378.jer.intel.com> <51DD5F05.6030206@broadcom.com>
In-Reply-To: <51DD5F05.6030206@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 16:17, Arend van Spriel wrote:
> On 07/10/2013 02:13 PM, Eliezer Tamir wrote:
>> Rename the file and correct all the places where it is included.
>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> ---
>>   include/net/busy_poll.h                         |  183
>> +++++++++++++++++++++++
>>   include/net/ll_poll.h                           |  183
>> -----------------------
> 
> Did you use -M command line option with 'git format-patch'?

No, I'm using stg so I was not aware of the option.
If this is how we expect people to send patches, why isn't this the default.

I will resend shortly with -M

Thanks,
Eliezer
