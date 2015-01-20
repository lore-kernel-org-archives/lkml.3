Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbbATN3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:29:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbATN3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:29:16 -0500
Date: Tue, 20 Jan 2015 14:28:26 +0100
From: Cyril Hrubis <chrubis@suse.cz>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: ltp-list@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
        libc-alpha@sourceware.org, lwn@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [LTP] The Linux Test Project has been released for JANUARY 2015
Message-ID: <20150120132826.GA11824@rei>
References: <20150119122310.GA27065@rei>
 <CA+icZUV53AWik-bS4a3DwgExD26nhCWxJWb-kGN_nAOWsikuLA@mail.gmail.com>
 <CA+icZUVSnYv3-rh6sBr8vgDsc80Qnr3yK_OZ6AezVHPrDcKXbg@mail.gmail.com>
 <20150120115625.GB11013@rei>
 <CA+icZUW3=TkMvEzs3DXZYt0BC5JjUtXiCsVSt3ikHwxPyzu3=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUW3=TkMvEzs3DXZYt0BC5JjUtXiCsVSt3ikHwxPyzu3=A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > Most of the failures comes from EBUSY while trying to umount
> > filesystems. Do you have gvfsd-trash running? That thing is known to
> > probe newly mounted filesystems preventing them from being unmounted for
> > a certain amount of time.
> >
> 
> Yupp, that popped up.
> How can I disable that gvfsd (here: Ubuntu/precise?

Just kill the process, or run the testcases via ssh session.

> And can this issue be documented?

Hmm, maybe we can change the test cases to complain loudly if the
process is found running.

-- 
Cyril Hrubis
chrubis@suse.cz
