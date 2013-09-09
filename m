Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3IIPdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:33:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:42334 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3IIPdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:33:52 -0400
X-IronPort-AV: E=Sophos;i="4.90,866,1371081600"; 
   d="scan'208";a="52027276"
Message-ID: <522DEA5C.6070608@citrix.com>
Date: Mon, 9 Sep 2013 16:33:48 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <stefan.bader@canonical.com>, <stefano.stabellini@eu.citrix.com>,
        <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH] Bug-fixes to enable PV ticketlock to work
 under	Xen PVHVM with Linux v3.12. (v2)
References: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/13 16:11, Konrad Rzeszutek Wilk wrote:
> 
> I had run some light performance tests with two guests - each over subscribed by
> 2:1 and running a spinlock_hog wherein each CPU tries to get a lock. The machine
> is a 4 CPU Intel, and each guest is running with 8 VCPUs.
> 
> It is not a perfect test-case - for that I have asked our internal performance
> engineer to test it out with various workloads and guests.
> 
> However it does demonstrate that these patches do work and they do not
> incur any performance regressions (and yes, they do show a performance
> improvement).

Good enough for me, let's get these into 3.12.

David
