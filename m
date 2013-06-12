Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3FLMpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:45:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:24079 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab3FLMpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:45:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,852,1363158000"; 
   d="scan'208";a="348684713"
Message-ID: <51B86D3F.5060108@linux.intel.com>
Date: Wed, 12 Jun 2013 15:44:47 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Avner Ben Hanoch <avnerb@mellanox.com>
CC: David Miller <davem@davemloft.net>,
        "sockperf-dev@googlegroups.com" <sockperf-dev@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Alex Rosenbaum <Alexr@mellanox.com>, Or Kehati <ork@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2 net-next 2/3] net: change sysctl_net_ll_poll into an
 unsigned int
References: <20130612111942.19288.12131.stgit@ladj378.jer.intel.com> <20130612112005.19288.81197.stgit@ladj378.jer.intel.com> <1A1A58E4DB34914CB8A94FD5DAE569ED7367A8BF@MTLDAG01.mtl.com>
In-Reply-To: <1A1A58E4DB34914CB8A94FD5DAE569ED7367A8BF@MTLDAG01.mtl.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 15:04, Avner Ben Hanoch wrote:
> Maybe better, I suggest opening an issue in sockperf issue system -
 > https://code.google.com/p/sockperf/issues/list
 > Then anyone can add notes or read/receive them.

Thanks,
I will do that once the review of the Linux patch is complete.

-Eliezer
