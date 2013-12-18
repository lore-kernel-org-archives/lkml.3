Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3LRPbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:31:37 -0500
Received: from smtp.citrix.com ([66.165.176.89]:33360 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3LRPbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:31:35 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85778632"
Message-ID: <52B1BFD4.7090702@citrix.com>
Date: Wed, 18 Dec 2013 15:31:32 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, <david.vrabel@citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH] allow xenfb initialization for hvm guests
References: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com> <1387367482.27441.123.camel@kazak.uk.xensource.com> <20131218151422.GF4934@phenom.dumpdata.com>
In-Reply-To: <20131218151422.GF4934@phenom.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/12/13 15:14, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 18, 2013 at 11:51:22AM +0000, Ian Campbell wrote:
>> On Tue, 2013-12-17 at 17:53 +0000, Stefano Stabellini wrote:
>>> There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
>>> As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
>>> Given that no Xen toolstacks configure a xenfb backend for x86 HVM
>>> guests, they are not affected.
>> and if a toolstack did I think it would be reasonable to expect the
>> kernel to at least try and drive it!
>>
>>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> I think David Vrabel is going to Nack it unless there is a test-case.
>
> I am saying that because in his previous statement for Wei's multi-page
> patches was that if there are no users (or at least no test-cases) then
> it should not be part of the kernel.

Without trying to presume too much, I really don't think he would.

This patch is taking an existing thing and permitting it to work in more
cases (which is a good change IMO).

The multi-page rings was completely brand new functionality with no
consumers at all, so no ability to verify the implementation.  It is a
completely different context.

~Andrew
