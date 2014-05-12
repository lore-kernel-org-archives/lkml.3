Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaELQuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:50:06 -0400
Received: from imap.thunk.org ([74.207.234.97]:35038 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaELQuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:50:02 -0400
Date: Mon, 12 May 2014 12:49:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] ext4: Do not destroy ext4_groupinfo_caches if
 ext4_mb_init() fails
Message-ID: <20140512164956.GA4150@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Andrey Tsyvarev <tsyvarev@ispras.ru>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
References: <1399883039-2978-1-git-send-email-tsyvarev@ispras.ru>
 <alpine.LFD.2.00.1405121707120.8008@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1405121707120.8008@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 05:08:41PM +0200, Lukáš Czerner wrote:
> > 
> > Caches from 'ext4_groupinfo_caches' may be in use by other mounts, which have already existed.
> > So, it is incorrect to destroy them when newly requested mount fails.
> > 
> > Found by Linux File System Verification project (linuxtesting.org).
> 
> Makes sense, thanks! Can you please share the test case which
> triggered this ? It might be worth including in xfstests.
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

				- Ted
