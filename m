Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaIPUuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:50:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaIPUuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:50:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
References: <cover.1410810247.git.milosz@adfin.com>
	<x49sijrxt1f.fsf@segfault.boston.devel.redhat.com>
	<CANP1eJF_LjNVeD838D-H=005jtGTvGY=h5wPZBHfT6Z9iuKK_g@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Sep 2014 16:49:31 -0400
In-Reply-To: <CANP1eJF_LjNVeD838D-H=005jtGTvGY=h5wPZBHfT6Z9iuKK_g@mail.gmail.com>
	(Milosz Tanski's message of "Tue, 16 Sep 2014 16:34:33 -0400")
Message-ID: <x49ioknuw84.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> Jeff,
>
> Which git repository do the man pages live in?

Hi, Milosz,

The download page is here:
https://www.kernel.org/doc/man-pages/download.html

And the git clone command is:
$ git clone http://git.kernel.org/pub/scm/docs/man-pages/man-pages

Cheers,
Jeff
