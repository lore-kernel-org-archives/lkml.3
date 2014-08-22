Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaHVMxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:53:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16839 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbaHVMw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:52:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,380,1406592000"; 
   d="scan'208";a="164142585"
Message-ID: <53F73D29.4020401@citrix.com>
Date: Fri, 22 Aug 2014 13:52:57 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Arianna Avanzini <avanzini.arianna@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC: <bob.liu@oracle.com>, <felipe.franciosi@citrix.com>, <axboe@fb.com>
Subject: Re: [PATCH RFC 3/4] xen, blkfront: introduce support for multiple
 hw queues
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com> <1408706404-6614-4-git-send-email-avanzini.arianna@gmail.com>
In-Reply-To: <1408706404-6614-4-git-send-email-avanzini.arianna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/14 12:20, Arianna Avanzini wrote:
> This commit introduces in xen-blkfront actual support for multiple
> hardware queues. The number of available hardware queues is gathered
> from the backend via XenStore; in case the expected XenStore key
> is not available, the frontend defaults to a single I/O ring.

Can you split this into a part that reactors blkfront handle multiple
queues and the part that adds the XenStore negotiation for this?

You will also need to to add documentation for the XenStore keys to the
blkif.h header in Xen.

David
