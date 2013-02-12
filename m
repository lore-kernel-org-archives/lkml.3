Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab3BLSG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:06:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933475Ab3BLSG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:06:27 -0500
Message-ID: <511A8491.5030407@redhat.com>
Date: Tue, 12 Feb 2013 19:06:09 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Bligh <alex@alex.org.uk>
CC: linux-kernel@vger.kernel.org, nbd-general@lists.sf.net,
        Paul Clements <Paul.Clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-2-git-send-email-pbonzini@redhat.com> <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk>
In-Reply-To: <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/02/2013 18:37, Alex Bligh ha scritto:
> For my education, why remove the FUA stuff?

Because I had no way to test it.

>>> > > Hmmm... the underlying storage could be md/dm RAIDs in which case FUA
>>> > > should be cheaper than FLUSH.
>> > 
>> > If someone ever wrote a virtio-blk backend that sits directly ontop
>> > of the Linux block layer that would be true.
> In this case we don't know what the backend is sitting on top of
> a-priori. It might be the current nbd server code, but it might
> not be.

Do you know of any other NBD server than the "official" one and qemu-nbd?

Paolo
