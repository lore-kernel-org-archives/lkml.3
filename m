Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbbATL5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:57:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbbATL5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:57:15 -0500
Date: Tue, 20 Jan 2015 12:56:25 +0100
From: Cyril Hrubis <chrubis@suse.cz>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: ltp-list@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
        libc-alpha@sourceware.org, lwn@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [LTP] The Linux Test Project has been released for JANUARY 2015
Message-ID: <20150120115625.GB11013@rei>
References: <20150119122310.GA27065@rei>
 <CA+icZUV53AWik-bS4a3DwgExD26nhCWxJWb-kGN_nAOWsikuLA@mail.gmail.com>
 <CA+icZUVSnYv3-rh6sBr8vgDsc80Qnr3yK_OZ6AezVHPrDcKXbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVSnYv3-rh6sBr8vgDsc80Qnr3yK_OZ6AezVHPrDcKXbg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > I will check my "iniza" setup of Linux v3.19-rc5 the "(runltp-)lite" way.
> >
> 
> Attached are the runltp-lite result and my kernel-config.
> 
> I see a lot of "unexpected" failures, can you comment on them?

Most of the failures comes from EBUSY while trying to umount
filesystems. Do you have gvfsd-trash running? That thing is known to
probe newly mounted filesystems preventing them from being unmounted for
a certain amount of time.

-- 
Cyril Hrubis
chrubis@suse.cz
