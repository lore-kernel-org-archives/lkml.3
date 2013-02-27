Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764Ab3B0TR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:17:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:35581 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3B0TRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:17:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,750,1355126400"; 
   d="scan'208";a="296762493"
Message-ID: <512E5BBD.2040803@linux.intel.com>
Date: Wed, 27 Feb 2013 21:17:17 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tom Herbert <therbert@google.com>
CC: Stephen Hemminger <stephen@networkplumber.org>,
        Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com> <20130227101354.15636ba5@nehalam.linuxnetplumber.net> <CA+mtBx85G3qD2_QP709kOMERP9T8v1W+ZNj12qnZWg_kALQtLg@mail.gmail.com>
In-Reply-To: <CA+mtBx85G3qD2_QP709kOMERP9T8v1W+ZNj12qnZWg_kALQtLg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/2013 20:47, Tom Herbert wrote:
> On Wed, Feb 27, 2013 at 10:13 AM, Stephen Hemminger
> <stephen@networkplumber.org> wrote:
>>
>> Have you looked at netmap? Seems like a cleaner user API for this.
>>
> That might be a bit orthogonal to this.  I believe the intent it to
> allow spin polling from socket calls without API change.

Exactly.

BTW, an interesting alternative to netmap would be to map a VF into 
userspace. (you would need to pre-allocate DMA memory regions and all of 
that RDMA-like stuff)
