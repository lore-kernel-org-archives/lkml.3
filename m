Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbbAAKG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 05:06:57 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:46319 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbbAAKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 05:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <20150101062816.GA2710@sudip-PC>
References: <1420060243-10685-2-git-send-email-lstoakes@gmail.com>
	<1420061623-11136-1-git-send-email-lstoakes@gmail.com>
	<20150101044756.GA3645@sudip-PC>
	<1420090813.6066.9.camel@perches.com>
	<20150101062816.GA2710@sudip-PC>
Date: Thu, 1 Jan 2015 10:06:55 +0000
Message-ID: <CAA5enKbPoAWc9bZk36F4ASex08VTf5C9Pz7bVFWgpE-ro9W7KQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] staging: rtl8192u: fix whitespace
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Joe Perches <joe@perches.com>, gregkh@linuxfoundation.org,
        Ana Rey <anarey@gmail.com>, mcgrof@do-not-panic.com,
        tapaswenipathak@gmail.com, Rui Silva <rmfrfs@gmail.com>,
        Jiayi Ye <yejiayily@gmail.com>, Greg Donald <gdonald@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 January 2015 at 06:28, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

>> > i may be wrong, but looks like you are doing many different things in the patch, not just whitespace errors.
>> > marked a few, please see inline -
...
> sorry for not trimming that. I noticed the big size while sending, but at that time the damage has already been done.
> but is it ok if we mention one thing in the commit log and do other things also? shouldn't we atleast mention that in the commit?

Hi Sudip,

I felt that 'additionally it removes inconsistent whitespace
throughout.' covered these cases, given there's a lot I also felt it'd
be more irritating for the community to receive several separate
patches for each individual *sub* type of whitespace removal beyond
those fixing checkpatch.pl messages, of course that kind of separation
could get pretty big and these patches are already big enough as it is
(this file had a lot of issues :)

As someone who's new to kernel development I'd be more than happy to
adjust this if the consensus is towards a different approach, however
I feel this is the least painful means of doing this particular patch
set.

Best, Lorenzo
