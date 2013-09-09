Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3IIKsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:48:17 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58512 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3IIKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130909194826.74d5df39@notabene.brown>
References: <CAE2SPAa-2NY3OKKSbmTY1fsaSD62BXwjNTRhGnrqdRGKd4z4KQ@mail.gmail.com>
	<20130909194826.74d5df39@notabene.brown>
Date: Mon, 9 Sep 2013 12:48:15 +0200
Message-ID: <CAE2SPAbAderJBX7cHxDLVdX5KF2uOqnLT9Pbim+90wXwNHh=6g@mail.gmail.com>
Subject: Re: [3.10.7] Reproductible soft lockup, recover but freeze even the mouse
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: dm-devel@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 11:48 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 9 Sep 2013 10:58:12 +0200 Bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
>
>> Hi,
>>
>> I experiment a soft lockup. during 20 s I have no mouse, could not
>> switch back to console and so on.
>>
>> I achieve to get a backtrace by echo 15 >
>> /proc/sys/kernel/hung_task_timeout_secs
>>
>> Seems file system related (hdd led is on).
>>
>> My filesystems are ext4 over raid0 so add some cc
>
> Appears to be "dm" raid0 rather than "md" raid0 - so not my area.
> May help to include dm-devel@redhat.com, and maybe include a description of
> the dm configuration.  e.g. "dmsetup table" output.

dmsetup  table
VOL-ROOT: 0 195305472 linear 9:1 2048
VOL-HOME: 0 1562501120 linear 9:1 195307520

>
> NeilBrown
