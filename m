Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab3INOnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 10:43:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42615 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab3INOnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 10:43:04 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CACW0xKV-jh2Zfz1-s0xX-NxYBixEF8Hf90jEbo0oouFE18CdyQ@mail.gmail.com>
References: <CA+icZUUkJgeUaJmNzAZQysV9dUHzwPzU7k3pn8vrThSD780xaQ@mail.gmail.com>
	<CACW0xKV-jh2Zfz1-s0xX-NxYBixEF8Hf90jEbo0oouFE18CdyQ@mail.gmail.com>
Date: Sat, 14 Sep 2013 16:43:02 +0200
Message-ID: <CA+icZUW6Z+exg9wm_up3wta9qX6Wp5WUZa-n+1q8a98-Kt-7Zg@mail.gmail.com>
Subject: Re: scripts/config: fix variable substitution command
From: Sedat Dilek <sedat.dilek@gmail.com>
To: =?UTF-8?Q?Cl=C3=A9ment_Chauplannaz?= <chauplac@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 4:21 PM, Clément Chauplannaz <chauplac@gmail.com> wrote:
> 2013/9/14 Sedat Dilek <sedat.dilek@gmail.com>:
>> Hi,
>>
>> The ChangeLog from [1] says:
>>
>> Commit 229455bc02b87f7128f190c4491b4ceffff38648 accidentally changed
>> the separator between sed `s' command and its parameters from ':' to
>> '/'.
>> Revert this change.
>>
>> Reported-and-tested-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>>
>> *** Bad commit reference: 229455bc02b87f7128f190c4491b4ceffff38648 ***
>> (Linus-tree)
>>
>> To quote [2] and see its EXAMPLE:
>>
>> "If you want to refer to a specific commit, don't just refer to the
>> SHA-1 ID of the commit. Please also include the oneline summary of
>> the commit, to make it easier for reviewers to know what it is about.
>>
>> Example:
>>
>> Commit e21d2170f36602ae2708 ("video: remove unnecessary
>> platform_set_drvdata()") removed the unnecessary
>> platform_set_drvdata(), but left the variable "dev" unused,
>> delete it."
>>
>> That's why the commit-id without the subject-line is no good help.
>> It does not help anyone when you reference a local GIT or linux-kbuild
>> GIT related commit-id.
>>
>> So, can you point me/us to the correct commit with subject, please?!
>> Is this patch even "CC: stable"?
>>
>> Thanks.
>>
>> Regards,
>> - Sedat -
>>
>>
>> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=86eb781889ec31f6421b86ab252ea609d456322d
>> [2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches#n112
>
>
> Hi Sedat,
>
> My apologies for that mistake. The initial commit, as present in Linus tree, is:
> 83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce - scripts/config: use sed's
> POSIX interface
>
> Thus, the commit message for this patch should read:
> scripts/config: fix variable substitution command
>
> Commit 83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce ("scripts/config: use sed's
> POSIX interface") accidentally changed the separator between sed `s' command
> and its parameters from ':' to '/'.
>
> Revert this change.
>
> Reported-and-tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
>

What means "pending" [1]?
Pending in sense of "we are working on it" or in the sense of
"exists-but-not-published".
I did not found a hint on the offline linux-kbuild ML.
BTW, the GIT repo of Yann is not browsable (which is sh*t for checking
commits quickl, I don't want to be forced to checkout).

- Sedat -

[1] http://marc.info/?l=linux-kbuild&m=137907590807755&w=2
[2] https://www.gitorious.org/linux-kconfig/linux-kconfig/
