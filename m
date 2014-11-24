Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaKXMPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:15:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaKXMPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:15:21 -0500
Message-ID: <5473214A.1020906@redhat.com>
Date: Mon, 24 Nov 2014 13:15:06 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org
Subject: Re: [PATCH v3 00/41] linux: towards virtio-1 guest support
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
In-Reply-To: <1416829787-14252-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/11/2014 12:52, Michael S. Tsirkin wrote:
> Based on patches by Cornelia Rusty and others, but
> with an API that should allow better static checking of code,
> and slightly more concervative changes in vring,net and blk.
> 
> Based on patches by Cornelia and others, but
> with an API that should allow better static checking of code,
> slightly more concervative changes in vring and drivers,
> and compatibility for existing drivers so that
> this series be applied before all drivers are converted.
> 
> virtio net,blk and scsi drivers have been converted.
> They now pass sparse without warnings.
> 
> net and blk patches have been tested on s390.
> scsi patches pass sparse so they are most likely
> ok too, but haven't been through testing yet -
> they can be dropped from patchset if necessary.
> 
> Please review, and consider for 3.19
> 
> David, assuming patches are acceptable, I'd like them all to be merged through
> virtio or vhost trees.  Could you please ack doing that for net related
> patches?

Patches 37-40:

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
