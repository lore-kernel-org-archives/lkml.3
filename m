Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab3BMAAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:00:19 -0500
Received: from mail.avalus.com ([89.16.176.221]:51385 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805Ab3BMAAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:00:16 -0500
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Alex Bligh <alex@alex.org.uk>
In-Reply-To: <511A8491.5030407@redhat.com>
Date: Wed, 13 Feb 2013 00:00:13 +0000
Cc: Alex Bligh <alex@alex.org.uk>, linux-kernel@vger.kernel.org,
        nbd-general@lists.sf.net, Paul Clements <Paul.Clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7412A1BC-0383-4539-BCCB-D14FB4206E1B@alex.org.uk>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-2-git-send-email-pbonzini@redhat.com> <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk> <511A8491.5030407@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo,

On 12 Feb 2013, at 18:06, Paolo Bonzini wrote:

> Il 12/02/2013 18:37, Alex Bligh ha scritto:
>> For my education, why remove the FUA stuff?
> 
> Because I had no way to test it.

I think my mods to the official NBD code support FUA (albeit not very efficiently)

>>>>>> Hmmm... the underlying storage could be md/dm RAIDs in which case FUA
>>>>>> should be cheaper than FLUSH.
>>>> 
>>>> If someone ever wrote a virtio-blk backend that sits directly ontop
>>>> of the Linux block layer that would be true.
>> In this case we don't know what the backend is sitting on top of
>> a-priori. It might be the current nbd server code, but it might
>> not be.
> 
> Do you know of any other NBD server than the "official" one and qemu-nbd?


Yes. I know one well (but it's not open source). NBD seems to be the 'goto protocol' for writing distributed block store drivers in user space.

-- 
Alex Bligh




