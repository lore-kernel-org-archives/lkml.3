Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaH3Va0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:30:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55996 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH3VaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:30:25 -0400
Date: Sat, 30 Aug 2014 23:30:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: gregkh@linuxfoundation.org
Cc: cmroliv@gmail.com, marcel@holtmann.org, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: patch "staging: remove nokia_hp4p driver
Message-ID: <20140830213022.GA17147@amd>
References: <14094295422869@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14094295422869@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is a note to let you know that I've just added the patch titled
> 
>     staging: remove nokia_hp4p driver
> -Re: [PATCH v6] Bluetooth: Add hci_h4p driver
> 
> to my staging git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> in the staging-next branch.
> 
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
> 
> The patch will also be merged in the next major kernel release
> during the merge window.
> 
> If you have any questions about this process, please let me know.

What is going on here? I get flamed for not cleaning up the driver,
because I cleaned it up before merging to -staging. Ok, so I did more
cleanups, sent 3 cleanup patches, no reaction on those, and now I got
a note that you are going to remove the driver...?

Please don't, I'd still like to clean the driver up and get included,
as n900's are still under active use.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
