Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab3FLIpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:45:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:46379 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab3FLIp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:45:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,850,1363158000"; 
   d="scan'208";a="315761680"
Message-ID: <51B83521.8080201@linux.intel.com>
Date: Wed, 12 Jun 2013 11:45:21 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amir Vadai <amirv@mellanox.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eliezer Tamir <eliezer@tamir.org.il>,
        Alex Rosenbaum <Alexr@mellanox.com>,
        Avner Ben Hanoch <avnerb@mellanox.com>, Or Kehati <ork@mellanox.com>
Subject: Re: [PATCH] sockperf: add SO_LL socketop support
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com> <51B73395.7070706@linux.intel.com> <51B83326.4080201@mellanox.com>
In-Reply-To: <51B83326.4080201@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 11:36, Amir Vadai wrote:
> On 11/06/2013 17:26, Eliezer Tamir wrote:
>> Add lls socket option support to sockperf.
>> Right now we always get the option before set to show the option is
>> working properly. We should probably remove that in an official release.
>> use --lls (value in usecs) to override global setting.
>> ---

> Eliezer Hi,
>
> Added sockperf maintainers to CC list.

Thank you.

Please note that I plan on revising this patch, so don't add it just 
yet. (I will CC the maintainers on further versions.)

-Eliezer
