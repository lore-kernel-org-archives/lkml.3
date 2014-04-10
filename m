Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030287AbaDJKIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:08:46 -0400
Received: from smtp.citrix.com ([66.165.176.89]:34314 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965147AbaDJKIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:08:44 -0400
X-IronPort-AV: E=Sophos;i="4.97,833,1389744000"; 
   d="scan'208";a="119824110"
Message-ID: <53466DA9.5050906@citrix.com>
Date: Thu, 10 Apr 2014 11:08:41 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3.13 08/22] Revert "xen: properly account for _PAGE_NUMA
 during xen pte translations"
References: <20140401040703.045139933@linuxfoundation.org>	<20140401040705.152847420@linuxfoundation.org> <CAKbGBLj3Ep7DkJsMFfRt0Kv80DTL6FS4RbOZWgZuesSU58JJhg@mail.gmail.com>
In-Reply-To: <CAKbGBLj3Ep7DkJsMFfRt0Kv80DTL6FS4RbOZWgZuesSU58JJhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/14 11:05, Steven Noonan wrote:
> I realize it's late to protest on this given that 3.13.9 is out, but
> what is the path forward for those experiencing the original issue
> that the reverted commit was intended to correct?

Disable NUMA_REBALANCING.

Or apply

https://lkml.org/lkml/2014/4/8/173

David
