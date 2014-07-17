Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbaGQQCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:02:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45065 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbaGQQCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:02:41 -0400
Date: Thu, 17 Jul 2014 18:02:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        apw@canonical.com, tytso@mit.edu, dwalter@google.com, bp@suse.de,
        neilb@suse.de, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140717160236.GD22791@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
 <1405612283.12363.10.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405612283.12363.10.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 08:51:23AM -0700, Joe Perches wrote:
> grep is a similar tool, just less automated.

And still, we don't want to encourage people with useless cleanups.

> I think it should really only be used in --file mode
> on drivers/staging/.

Also dumb idea - having to look at a single patch "correcting" a whole
file in staging without any explanation why it is done is not something
we want to encourage either.

People cleaning up staging should first understand what they're doing
and not listen to some script what to do.

> I wouldn't mind adding some additional "yes, I really
> mean to do this" cmd-line flag when it's used on any
> file outside of staging with some additional warning
> that "--file" is discouraged outside of staging when
> it's not there.

No, checkpatch should only check patches and not whole file. It is
wrong. Fullstop.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
