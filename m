Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaJAPpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:45:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaJAPpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:45:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andreas Dilger <adilger@dilger.ca>, Matthew Wilcox <willy@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
	<15705.1412070301@turing-police.cc.vt.edu>
	<20140930144854.GA5098@wil.cx>
	<123795.1412088827@turing-police.cc.vt.edu>
	<20140930160841.GB5098@wil.cx>
	<15704.1412109476@turing-police.cc.vt.edu>
	<A8F88370-512D-45D0-8414-C478D64E46E5@dilger.ca>
	<62749.1412113956@turing-police.cc.vt.edu>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 01 Oct 2014 11:45:47 -0400
In-Reply-To: <62749.1412113956@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Tue, 30 Sep 2014 17:52:36 -0400")
Message-ID: <x49r3yrn68k.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> As long as we're at it, if we go that route we probably *also* want a
> way for a program to specify it at open() time (for instance, for the
> use of backup programs) - that should minimize the infamous "everything
> runs like a pig after the backup finishes running because  the *useful*
> pages are all cache-cold".

This sounds an awful lot like posix_fadvise' POSIX_FADV_NOREUSE flag.
Whether the implementation lives up to your expectations is another
matter, but at least the interface is already there.

Cheers,
Jeff
