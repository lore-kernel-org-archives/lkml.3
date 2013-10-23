Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3JWMHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:07:35 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:57205 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3JWMHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:07:33 -0400
MIME-Version: 1.0
In-Reply-To: <1382527624.16097.23.camel@dabdike.quadriga.com>
References: <1382527624.16097.23.camel@dabdike.quadriga.com>
Date: Wed, 23 Oct 2013 13:07:32 +0100
X-Google-Sender-Auth: TLTcFof8A5EIqcRNmItXDJh80sI
Message-ID: <CA+55aFzo-sA4P_rMC1wWfLp50QswfP0GdLxMQ+Wbw8ArK5capw@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 3.12-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 12:27 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

No it's not. "Already up-to-date.".

Also, even if it was, I'm not feeling the reason to pull it. "Cleanup
sprintf formatting of firmware version"? "Remove superfluous mask of
pcie_cap_reg"? Seriously?

Multi-hundred-line pull requests that come in this late had better
look a bit more serious than that.

There's *HUNDREDS* of lines of changes, all of which seems to come
from the change to use the (admittedly much superior) native bit
handling fucntions, instead of the shit-for-brains abortion that is
"esas2r_lock_set/clear_flags()"

And I see why you'd want to get rid of that horrible crap, but I see
absolutely _zero_ reason to do it in -rc7.

As far as I can tell from the patch, a few lines are for actual
problems like oopses. And the rest is pure and utter garbage that
should have happened during the merge window.

So I literally *cannot* pull this, because the git tree doesn't
contain what you said it contains. But even if it did, I would not
*want* to pull this kind of completely brainless crap.

You need to curse at the people who send you this kind of crap.
Seriously. This is not acceptablee timing.

              Linus
