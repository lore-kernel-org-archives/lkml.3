Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbaFZRUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:20:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbaFZRUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:20:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com>
	<x49wqc34psf.fsf@segfault.boston.devel.redhat.com>
	<53AC461D.6080004@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 26 Jun 2014 13:20:43 -0400
In-Reply-To: <53AC461D.6080004@kernel.dk> (Jens Axboe's message of "Thu, 26
	Jun 2014 10:11:09 -0600")
Message-ID: <x49oaxf4mfo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2014-06-26 10:08, Jeff Moyer wrote:
>> Joe Lawrence <joe.lawrence@stratus.com> writes:
>>
>>> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
>>>          tags.
>>>
>>> Joe Lawrence (2):
>>>    block,scsi: verify return pointer from blk_get_request
>>>    block,scsi: convert and handle ERR_PTR from blk_get_request
>>
>> Jens,
>>
>> Can you pick this series up?  It actually fixes a NULL pointer
>> dereference that can happen if (for example) a usb optical drive is
>> removed while an application is using it.
>
> Yeah I'll pick it up, opening up the 3.17 branches soon.

Thanks, Jens.  Joe, the patches don't apply anymore... would you mind
sending an updated set so Jens doesn't have to do the fixups?  I think
you also need to convert blk_mq_alloc_request, I didn't see that in your
patch.

Thanks!
Jeff
