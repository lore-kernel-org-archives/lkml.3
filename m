Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbaGPEgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:36:18 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41582 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaGPEgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:36:14 -0400
MIME-Version: 1.0
In-Reply-To: <1405483722.14773.12.camel@joe-AO725>
References: <1405193128-6848-1-git-send-email-bobby.prani@gmail.com>
 <CAJhHMCC1bY5ras7-W17Qh7yZq5-_eD0C-CJfa09ZpjWNoTOZ=w@mail.gmail.com> <1405483722.14773.12.camel@joe-AO725>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 16 Jul 2014 00:35:43 -0400
Message-ID: <CAJhHMCDNj2H7VC+5tMeWqPGbMQpDD-ycZ2HGXoeMPwCn7hTuKg@mail.gmail.com>
Subject: Re: [PATCH 1/1] scripts/get_maintainer: increase threshold for
 --follow to reduce time
To: Joe Perches <joe@perches.com>
Cc: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 12:08 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-07-15 at 22:23 -0400, Pranith Kumar wrote:
>> ping?
>>
>> On Sat, Jul 12, 2014 at 3:25 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>> > get_maintainer tries to follow files with a matching threshold of default 50%.
>> > This is not really necessary as we do not change a file and move it in the same
>> > commit usually. Increasing the threshold to 90% should be sufficient.
<snip>
> While I understand the goal, I wonder if this should
> be in a .gitconfig, not in get_maintainers at all.
>
> (git doesn't seem to have a config entry for score though)
>
> If not, the % should probably be cmd-line configurable.
>
>

The problem is with the default which is at 50% now. That means that a
commit needs to have changed a file by more than 50% -and- moved it in
the same commit. This is highly discouraged and unlikely to happen in
our case.

Even if we have this a cmd-line configuration, setting the default to
90% really makes sense, no?

-- 
Pranith
