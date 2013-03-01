Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3CAQMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:12:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3CAQMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:12:10 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] blockconsole: use CON_ALLDATA
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
	<1362087602-8979-6-git-send-email-joern@logfs.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 01 Mar 2013 11:11:58 -0500
In-Reply-To: <1362087602-8979-6-git-send-email-joern@logfs.org> (Joern Engel's
	message of "Thu, 28 Feb 2013 16:39:58 -0500")
Message-ID: <x49txov14mp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joern Engel <joern@logfs.org> writes:

> Blockconsole should really see every message ever printed.  The
> alternative is to try debugging with information like this:
> [166135.633974] Stack:
> [166135.634016] Call Trace:
> [166135.634029]  <IRQ>
> [166135.634156]  <EOI>
> [166135.634177] Code: 00 00 55 48 89 e5 0f 1f 44 00 00 ff 15 31 49 80 00 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00
> [166135.634384]  48 8b 14 25 98 24 01 00 48 8d 14 92 48 8d 04 bd 00 00 00 00

What was your log level set to at the time?  By default, all of the
information for a kernel panic should show up on the console, no?

Cheers,
Jeff
