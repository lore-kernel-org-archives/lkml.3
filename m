Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaHDOad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:30:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35121 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaHDOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:30:32 -0400
Date: Mon, 4 Aug 2014 16:30:29 +0200
From: Pavel Machek <pavel@denx.de>
To: Kalle Valo <kvalo@adurom.com>
Cc: Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        apw@canonical.com, tytso@mit.edu, dwalter@google.com, bp@suse.de,
        neilb@suse.de, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140804143029.GC24261@amd.pavel.ucw.cz>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
 <1405612283.12363.10.camel@joe-AO725>
 <20140717160236.GD22791@pd.tnic>
 <87vbqq9d51.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbqq9d51.fsf@purkki.adurom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-22 08:27:22, Kalle Valo wrote:
> Borislav Petkov <bp@alien8.de> writes:
> 
> > No, checkpatch should only check patches and not whole file. It is
> > wrong. Fullstop.
> 
> Please don't remove --file, I use it all the time when maintaining
> ath6kl and ath10k. It's a lot easier in my workflow to test the whole
> driver in one go than start testing individual patches.

Exactly. Also, with --file, you have nice place to write warning
"please don't do cleanups just because of this"...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
