Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaLaSEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 13:04:32 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34483 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaLaSEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 13:04:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141231174936.GB1922@hudson.localdomain>
References: <1420047298-7798-1-git-send-email-baspeters93@gmail.com>
	<20141231174936.GB1922@hudson.localdomain>
Date: Wed, 31 Dec 2014 19:04:30 +0100
Message-ID: <CAOgR63d6FNxntkBaSWM6ozibYGzajt07OLiM2XcszJarSaGX6A@mail.gmail.com>
Subject: Re: [PATCH] Drivers: isdn: gigaset: checkpatch cleanup
From: Bas Peters <baspeters93@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, Bas Peters <baspeters93@gmail.com>,
        hjlipp@web.de, tilman@imap.cc, isdn@linux-pingi.de,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-31 18:49 GMT+01:00 Jeremiah Mahler <jmmahler@gmail.com>:
> Bas,
>
> On Wed, Dec 31, 2014 at 06:34:58PM +0100, Bas Peters wrote:
>> Fixed many checkpatch.pl complaints, ranging from whitespace issues to
>> reportedly deprecated function and macro usage.
>>
> One patch should fix one type of problem.  This needs to be broken up
> in to individual patches.
>
>> I have not been able to test the code as I do not have access to the
>> hardware but since no new features were really added I don't think that
>> should pose a problem.
>>
>> There are still some checkpatch complaints, particularly concerning
>> potentially unnecessary 'out of memory' messages. I will provide patches
>> for these complaints when I figure out the reason behind it and what to
>> do about it.
>>
>> NOTE: This is my first patch (ever). I have attempted to follow all
>> guidelines provided, but I probably will have missed some. If you have
>> any comments regarding the quality of this patch or suggestions as to
>> what I could do better in the future, please let me know.
>>
> You are ambitious.  I would suggest trying a smaller patch first to
> make sure you are doing everything right.

With 'smaller patch', do you refer to less files at once or a different driver?
Is it generally preferred to send patches that relate to the same
issue (changes to a single file,
grouping of patches to tackle the same issue, such as conversion of a
specific function) over
patch(sets) that deal with an entire driver?

Thanks for the advice!

>
>> Signed-off-by: Bas Peters <baspeters93@gmail.com>
>> ---
>>  drivers/isdn/gigaset/asyncdata.c   |  9 +++--
>>  drivers/isdn/gigaset/bas-gigaset.c | 80 ++++++++++++++++++++------------------
>>  drivers/isdn/gigaset/capi.c        |  5 ++-
>>  drivers/isdn/gigaset/common.c      |  8 ++--
>>  drivers/isdn/gigaset/ev-layer.c    | 38 +++++++++++-------
>>  drivers/isdn/gigaset/gigaset.h     |  4 +-
>>  drivers/isdn/gigaset/i4l.c         | 12 +++---
>>  drivers/isdn/gigaset/interface.c   | 10 ++---
>>  drivers/isdn/gigaset/isocdata.c    |  3 ++
>>  drivers/isdn/gigaset/proc.c        | 17 +++++---
>>  drivers/isdn/gigaset/usb-gigaset.c | 46 +++++++++++++++-------
>>  11 files changed, 141 insertions(+), 91 deletions(-)
>>
>> diff --git a/drivers/isdn/gigaset/asyncdata.c b/drivers/isdn/gigaset/asyncdata.c
> [...]
>
> --
> - Jeremiah Mahler
