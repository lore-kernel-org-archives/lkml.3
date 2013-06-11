Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3FKGtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:49:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:19385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3FKGtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:49:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,843,1363158000"; 
   d="scan'208";a="253334397"
Message-ID: <51B6C87B.70101@linux.intel.com>
Date: Tue, 11 Jun 2013 09:49:31 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        erdnetdev@gmail.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH v10 net-next 0/6] net: low latency Ethernet device polling
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com> <20130610.134116.1913599114372510768.davem@davemloft.net> <51B68AA6.1050105@linux.intel.com> <20130610.212443.1096102996038709384.davem@davemloft.net>
In-Reply-To: <20130610.212443.1096102996038709384.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 07:24, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Date: Tue, 11 Jun 2013 05:25:42 +0300
>
>> Here is the text from the RFC and v2 cover letters, updated and
>> merged.  If this is too long, please tell me what you think should
>> be removed.
>
> It's perfect, and since this went through so many iterations I
> included the changelog too.
>

Thank you.

I would like to hear opinions on what needs to be added to make this
feature complete.

The list I have so far is:
1. add a socket option
2. support for poll/select
3. support for epoll

Also, would you accept a trailing whitespace cleanup patch for
fs/select.c?

-Eliezer
