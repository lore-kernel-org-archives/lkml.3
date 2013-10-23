Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3JWPzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 11:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab3JWPy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 11:54:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Jerry Fredin <jerry.fredin@netapp.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] block/aio: Enable sysfs nomerge control for I/O requests in the plug list
References: <CAB-428koa_AtGr_sTW0xWZAqNgqmxKkeB5wGBB6QwxKx=qu3uA@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 23 Oct 2013 11:54:51 -0400
In-Reply-To: <CAB-428koa_AtGr_sTW0xWZAqNgqmxKkeB5wGBB6QwxKx=qu3uA@mail.gmail.com>
	(Alireza Haghdoost's message of "Tue, 22 Oct 2013 18:54:25 -0500")
Message-ID: <x49txg8x9ro.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alireza Haghdoost <alireza@cs.umn.edu> writes:

> This patch enables the sysfs to control I/O request merge
> functionality in the plug list. While this control has been
> implemented for the request queue, it was dismissed in the plug list.
> Therefore, block layer merges requests together (or attempt to merge)
> even if the merge capability was disable using sysfs nomerge parameter
> value 2.

Yeah, this looks like an oversight.  Your mailer really munged up the
patch, though.  You should fix that and resend (unless Jens just fixes
it up manually).  Also, please specify the -p option to diff or just use
git diff.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
