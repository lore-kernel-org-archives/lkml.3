Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbaFZQI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbaFZQIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:08:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Joe Lawrence <joe.lawrence@stratus.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 26 Jun 2014 12:08:16 -0400
In-Reply-To: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com> (Joe
	Lawrence's message of "Wed, 4 Jun 2014 15:20:31 -0400")
Message-ID: <x49wqc34psf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:

> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
>         tags.
>
> Joe Lawrence (2):
>   block,scsi: verify return pointer from blk_get_request
>   block,scsi: convert and handle ERR_PTR from blk_get_request

Jens,

Can you pick this series up?  It actually fixes a NULL pointer
dereference that can happen if (for example) a usb optical drive is
removed while an application is using it.

Thanks!
Jeff
