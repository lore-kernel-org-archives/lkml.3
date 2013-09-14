Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3INMVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:21:52 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:33093 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3INMVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:21:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 14 Sep 2013 14:21:49 +0200
Message-ID: <CA+icZUUkJgeUaJmNzAZQysV9dUHzwPzU7k3pn8vrThSD780xaQ@mail.gmail.com>
Subject: Re: scripts/config: fix variable substitution command
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Clement Chauplannaz <chauplac@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The ChangeLog from [1] says:

Commit 229455bc02b87f7128f190c4491b4ceffff38648 accidentally changed
the separator between sed `s' command and its parameters from ':' to
'/'.
Revert this change.

Reported-and-tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>

*** Bad commit reference: 229455bc02b87f7128f190c4491b4ceffff38648 ***
(Linus-tree)

To quote [2] and see its EXAMPLE:

"If you want to refer to a specific commit, don't just refer to the
SHA-1 ID of the commit. Please also include the oneline summary of
the commit, to make it easier for reviewers to know what it is about.

Example:

Commit e21d2170f36602ae2708 ("video: remove unnecessary
platform_set_drvdata()") removed the unnecessary
platform_set_drvdata(), but left the variable "dev" unused,
delete it."

That's why the commit-id without the subject-line is no good help.
It does not help anyone when you reference a local GIT or linux-kbuild
GIT related commit-id.

So, can you point me/us to the correct commit with subject, please?!
Is this patch even "CC: stable"?

Thanks.

Regards,
- Sedat -


[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=86eb781889ec31f6421b86ab252ea609d456322d
[2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches#n112
