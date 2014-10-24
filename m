Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbaJXP4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:56:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaJXP4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:56:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
References: <cover.1413923420.git.milosz@adfin.com>
	<cover.1413923420.git.milosz@adfin.com>
	<ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 24 Oct 2014 11:55:23 -0400
In-Reply-To: <ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
	(Milosz Tanski's message of "Tue, 21 Oct 2014 16:46:59 -0400")
Message-ID: <x49k33po42c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> Filesystems that generic_file_read_iter will not be allowed to perform
> non-blocking reads. This only will read data if it's in the page cache and if
> there is no page error (causing a re-read).
>
> Christoph Hellwig wrote the filesystem specify code (cifs, ofs, shm, xfs).
>
> Signed-off-by: Milosz Tanski <milosz@adfin.com>

Add in the 2 hunks from the other patches, as suggested by Christoph,
and you can add my:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
