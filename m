Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3EUNQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:16:55 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:53775 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886Ab3EUNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:16:53 -0400
Message-ID: <519B7355.9090303@mellanox.com>
Date: Tue, 21 May 2013 16:15:01 +0300
From: Alex Rosenbaum <alexr@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Dave Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v3 net-next 0/4] net: low latency Ethernet device polling
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com> <519B632F.7040202@mellanox.com> <519B68A4.3010406@linux.intel.com>
In-Reply-To: <519B68A4.3010406@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2013 3:29 PM, Eliezer Tamir wrote:
> What benchmarks are you using to test poll/select/epoll?
for epoll/select latency tests we are using sockperf as performance 
latency tool: https://code.google.com/p/sockperf/
It is a client-server based tool and it supported ping-pong, throughput, 
and under-load test type.
For epoll, you will need to define a 'feedfile' ("-f filepathname") 
which has a list of TCP and/or UDP socket and defined your IO mux type 
("-F epoll").

thanks for all the clarifications.

- Alex Rosenbaum
