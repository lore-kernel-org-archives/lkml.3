Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaFDTgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:36:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaFDTgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:36:40 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 1/2] block,scsi: verify return pointer from blk_get_request
References: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com>
	<1401909633-25931-2-git-send-email-joe.lawrence@stratus.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Jun 2014 15:36:34 -0400
In-Reply-To: <1401909633-25931-2-git-send-email-joe.lawrence@stratus.com> (Joe
	Lawrence's message of "Wed, 4 Jun 2014 15:20:32 -0400")
Message-ID: <x49ha40o4al.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:

> The blk-core dead queue checks introduce an error scenario to
> blk_get_request that returns NULL if the request queue has been
> shutdown. This affects the behavior for __GFP_WAIT callers, who should
> verify the return value before dereferencing.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Acked-by: Jiri Kosina <jkosina@suse.cz> [for pktdvd]
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Heh.  Just reviewed by would be better.  ;-)  I'm sure Jens can sort
that out.

-Jeff
