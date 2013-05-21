Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3EUSPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:15:25 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:34604 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab3EUSPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:15:24 -0400
Message-ID: <1369160115.2615.51.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v3 net-next 0/4] net: low latency Ethernet device polling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Alex Rosenbaum <alexr@mellanox.com>, Dave Miller <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 19:15:15 +0100
In-Reply-To: <519B68A4.3010406@linux.intel.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	 <519B632F.7040202@mellanox.com> <519B68A4.3010406@linux.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19882.005
X-TM-AS-Result: No--18.080000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 15:29 +0300, Eliezer Tamir wrote:
> Many of the questions you asked are covered in our RFC cover letter, but 
> I will touch them briefly
> 
> On 21/05/2013 15:06, Alex Rosenbaum wrote:
> > 1. It seem this patch does not cover epoll/select and such IO muxing APIs?
> 
> We are thinking about how to implement epoll support as one of the next 
> steps.
>
> What benchmarks are you using to test poll/select/epoll?
[...]

I raised this issue back at Plumbers and I thought Jesse said poll() was
covered.  It's likely to be a bit of a toy without that.  Also, UDP?

Solarflare uses a wide range of benchmarks.  Of the publicly available
applications, I believe Ixia Chariot uses (or can use) epoll.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

