Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaCEKhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:37:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:4689 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaCEKhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:37:00 -0500
X-IronPort-AV: E=Sophos;i="4.97,592,1389744000"; 
   d="scan'208";a="106751093"
Message-ID: <5316FE49.1020203@citrix.com>
Date: Wed, 5 Mar 2014 10:36:57 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen <xen-devel@lists.xenproject.org>
Subject: Re: [patch 4/5] xen: Validate online cpus in set_affinity
References: <20140304202425.102779779@linutronix.de> <20140304203100.978031089@linutronix.de>
In-Reply-To: <20140304203100.978031089@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/14 20:43, Thomas Gleixner wrote:
> The user space interface does not filter out offline cpus. It merily
> verifies that the mask contains at least one online cpu. So the
> selector in the irq chip implementation needs to make sure to pick
> only an online cpu because otherwise:
> 
>      Offline Core 1
>      Set affinity to 0xe
>      Selector will pick first set bit, i.e. core 1

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thanks.

David
