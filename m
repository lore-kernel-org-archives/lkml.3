Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaILKuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:50:46 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46690 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaILKup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:50:45 -0400
X-IronPort-AV: E=Sophos;i="5.04,512,1406592000"; 
   d="scan'208";a="170895271"
Message-ID: <5412D002.7050800@citrix.com>
Date: Fri, 12 Sep 2014 11:50:42 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <avanzini.arianna@gmail.com>
CC: <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <bob.liu@oracle.com>, <felipe.franciosi@citrix.com>, <axboe@fb.com>
Subject: Re: [PATCH RFC 3/4] xen, blkfront: introduce support for multiple
 hw queues
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com> <1408706404-6614-4-git-send-email-avanzini.arianna@gmail.com> <53F73D29.4020401@citrix.com> <20140911233615.GA2052@gmail.com>
In-Reply-To: <20140911233615.GA2052@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 00:36, Arianna Avanzini wrote:
> On Fri, Aug 22, 2014 at 01:52:57PM +0100, David Vrabel wrote:
> 
>> You will also need to to add documentation for the XenStore keys to the
>> blkif.h header in Xen.
>>
> 
> Thank you for pointing that out. I'll add the documentation when/if I'll
> drop the RFC tag, if it's OK (I'll need to send a separate patch to
> xen-devel, I think).

ABI specification/documentation should be the first patch, not left
until the end!

Since the ABI is undergoing review in combination with the blkback/front
implementation, it would be fine to just patch Linux's copy in
include/xen/interface/io/blkif.h

David
