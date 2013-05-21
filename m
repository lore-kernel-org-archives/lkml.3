Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3EUR2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:28:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:35000 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3EUR2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:28:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,715,1363158000"; 
   d="scan'208";a="305803539"
Message-ID: <519BAEB6.2010206@linux.intel.com>
Date: Tue, 21 May 2013 20:28:22 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v4 net-next 1/4] net: implement support for low latency
 socket polling
References: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>  <20130521142650.18498.71715.stgit@ladj378.jer.intel.com> <1369157030.2615.24.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1369157030.2615.24.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/2013 20:23, Ben Hutchings wrote:
> On Tue, 2013-05-21 at 17:26 +0300, Eliezer Tamir wrote:

> Microseconds, not cycles.

> us, not ms.

> CONFIG_X86_TSC

> Should be done before testing ndo_ll_poll above, so you can avoid
> repeating the indirections.

> Typo: 'permanent'.
>
> Ben.
>
Thanks!
-Eliezer
