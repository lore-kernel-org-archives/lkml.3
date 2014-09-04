Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaIDQAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:00:20 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35858 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaIDQAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:00:18 -0400
MIME-Version: 1.0
In-Reply-To: <32705.1409149899@warthog.procyon.org.uk>
References: <cover.1407948737.git.milosz@adfin.com>
	<53EB992D.6040608@adfin.com>
	<32705.1409149899@warthog.procyon.org.uk>
Date: Thu, 4 Sep 2014 12:00:17 -0400
Message-ID: <CANP1eJFOw+2etaocge_h4tj7wigjNpcD0KsNW41pWaXFdToyDQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
From: Milosz Tanski <milosz@adfin.com>
To: David Howells <dhowells@redhat.com>
Cc: "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's fine by me. If you'd like me to send a updated/fixed pull
request (much easier then patches over email) for these changes in my
code I can do that as well.

On Wed, Aug 27, 2014 at 10:31 AM, David Howells <dhowells@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> +     if (__fscache_unuse_cookie(cookie))
>> +             __fscache_wake_unused_cookie(cookie);
>
> I've replaced these two lines with "fscache_unuse_cookie(cookie);" as
> NeilBrown suggested.
>
> David



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
