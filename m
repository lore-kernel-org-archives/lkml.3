Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3CCORg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 09:17:36 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55204 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3CCORf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 09:17:35 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXxJ=4fuKCOckLfvc=V9XV5u8qy07nhVB_9jt5LPvHJ+A@mail.gmail.com>
References: <CA+icZUUWqeHdgjP-Hi630DDwO65evWUUCX2tBYfj=Cn1w3dEAg@mail.gmail.com>
	<513355C5.2010505@kernel.org>
	<CA+icZUXxJ=4fuKCOckLfvc=V9XV5u8qy07nhVB_9jt5LPvHJ+A@mail.gmail.com>
Date: Sun, 3 Mar 2013 15:17:33 +0100
Message-ID: <CA+icZUUQypdXaqYApQ-uP=q02RBKvEvpqW3sjSh4PTOowzECoQ@mail.gmail.com>
Subject: Re: [git.k.o] gitweb->cgit: Re-add Git snapshot tarball feature
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: webmaster@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 3:13 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sun, Mar 3, 2013 at 2:53 PM, Konstantin Ryabitsev <mricon@kernel.org> wrote:
>> On 03/03/13 06:34 AM, Sedat Dilek wrote:
>>> Hi,
>>>
>>> unfortunately, the Git snapshot tarball feature was dropped when
>>> switching from gitweb->cgit interface.
>>>
>>> For example the Freetz router project extracted the Kbuild-system out
>>> of Linux-kernel sources.
>>> This is no more possible (see old version [2] and new one in [3]).
>>> Freetz introduced "git_archive" checkout method [3] to fix it.
>>>
>>> Can you please re-add?
>>
>> I've cautiously re-enabled the snapshot feature. I'll keep an eye on the
>> impact this has on the system load and the cache size.
>>
>
> Thanks.
>
> Each commit-id it should be downloadable as a snapshot tarball, not
> only he latest commit-id.
>
> LATEST: http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/snapshot/linux-a7c1120d2dcc83691bafa034d98f70285757e826.tar.gz
>
> PREVIOUS: Not available as TGZ
>

$ wget http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/snapshot/linux-6ec40b423032ca769c96fbf9a080db822821893d.tar.gz

It's downloadable, but not visible in the CGIT website if you select
the commit-id (missing download section and link).

See <http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6ec40b423032ca769c96fbf9a080db822821893d>.

- Sedat -

> I would also like to see it as on fdo in the form:
>
> $GIT_URL/$PATH/snapshot/$PKG_NAME-$COMMIT_ID.tar.gz
>
> $GIT_URL=http://cgit.freedesktop.org
> PATH=xorg/driver/xf86-video-intel
> PKG_NAME=xf86-video-intel
> COMMIT_ID=995abb46754eba7524afcb852159a31ea19add82
>
> EXAMPLE:
> http://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/xf86-video-intel-995abb46754eba7524afcb852159a31ea19add82.tar.gz
>
> /me is no cgit expert...
>
> - Sedat -
>
>
>> Regards,
>> --
>> Konstantin Ryabitsev
>> Systems Administrator
>> Linux Foundation, kernel.org
>> Montréal, Québec
>>
