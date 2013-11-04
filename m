Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3KDQJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:09:52 -0500
Received: from smtp.citrix.com ([66.165.176.89]:42731 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3KDQJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:09:50 -0500
X-IronPort-AV: E=Sophos;i="4.93,633,1378857600"; 
   d="scan'208";a="70356238"
Message-ID: <5277C6B3.1000500@citrix.com>
Date: Mon, 4 Nov 2013 17:09:23 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH v3] p2m: use GNTTABOP_unmap_and_duplicate
 if available
References: <1383579524-12465-1-git-send-email-roger.pau@citrix.com> <1383580147.8826.104.camel@kazak.uk.xensource.com>
In-Reply-To: <1383580147.8826.104.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 16:49, Ian Campbell wrote:
> On Mon, 2013-11-04 at 16:38 +0100, Roger Pau Monne wrote:
>> The new GNTTABOP_unmap_and_duplicate operation 
> 
> I don't see this op in mainline Xen anywhere...
> 
> Was it part of Stefano's original swiotlb for ARM stuff? If so we've
> dropped that approach for ARM and the new solution doesn't require
> hypervisor changes so the upstreaming of this hypercall ended, so you'd
> have to pick it up and complete that work if you want to use it.

It's not part of the ARM stuff, the patch to add that OP is here:

http://lists.xen.org/archives/html/xen-devel/2013-07/msg02825.html

I guess I will need to resend that also.

