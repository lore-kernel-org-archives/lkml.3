Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3IMH37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:29:59 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54529 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab3IMH34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:29:56 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE2SPAbAderJBX7cHxDLVdX5KF2uOqnLT9Pbim+90wXwNHh=6g@mail.gmail.com>
References: <CAE2SPAa-2NY3OKKSbmTY1fsaSD62BXwjNTRhGnrqdRGKd4z4KQ@mail.gmail.com> <20130909194826.74d5df39@notabene.brown> <CAE2SPAbAderJBX7cHxDLVdX5KF2uOqnLT9Pbim+90wXwNHh=6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [3.10.7] Reproductible soft lockup, recover but freeze even the mouse
From: roucaries.bastien@gmail.com
Date: Fri, 13 Sep 2013 09:29:49 +0200
To: dm-devel@redhat.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Message-ID: <eef6aca5-3ec5-488c-bd9f-09930313ba37@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Bastien ROUCARIES <roucaries.bastien@gmail.com> a écrit :
>On Mon, Sep 9, 2013 at 11:48 AM, NeilBrown <neilb@suse.de> wrote:
>> On Mon, 9 Sep 2013 10:58:12 +0200 Bastien ROUCARIES
>> <roucaries.bastien@gmail.com> wrote:
>>
>>> Hi,
>>>
>>> I experiment a soft lockup. during 20 s I have no mouse, could not
>>> switch back to console and so on.
>>>
>>> I achieve to get a backtrace by echo 15 >
>>> /proc/sys/kernel/hung_task_timeout_secs
>>>
>>> Seems file system related (hdd led is on).

If needed I could add trace. Sorry for double post Google phone mail is by default HTML I expect now plain text.

Bastien


>>> My filesystems are ext4 over raid0 so add some cc
>>
>> Appears to be "dm" raid0 rather than "md" raid0 - so not my area.
>> May help to include dm-devel@redhat.com, and maybe include a
>description of
>> the dm configuration.  e.g. "dmsetup table" output.
>
>dmsetup  table
>VOL-ROOT: 0 195305472 linear 9:1 2048
>VOL-HOME: 0 1562501120 linear 9:1 195307520
>
>>
>> NeilBrown

-- 
Envoyé de mon téléphone Android avec K-9 Mail. Excusez la brièveté.
