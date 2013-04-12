Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3DLPoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:44:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab3DLPoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:44:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 05/33] char: add aio_{read,write} to /dev/{null,zero}
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
	<1363883754-27966-6-git-send-email-koverstreet@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 12 Apr 2013 11:43:44 -0400
In-Reply-To: <1363883754-27966-6-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Thu, 21 Mar 2013 09:35:26 -0700")
Message-ID: <x49hajbu53j.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> From: Zach Brown <zab@redhat.com>
>
> These are handy for measuring the cost of the aio infrastructure with
> operations that do very little and complete immediately.
>
> Signed-off-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Asai Thambi S P <asamymuthupa@micron.com>
> Cc: Selvan Mani <smani@micron.com>
> Cc: Sam Bradshaw <sbradshaw@micron.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
