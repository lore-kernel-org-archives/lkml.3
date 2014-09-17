Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbaIQUYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:24:54 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:47947 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaIQUYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <32201.1410985387@warthog.procyon.org.uk>
References: <cover.1407948737.git.milosz@adfin.com>
	<53EB992D.6040608@adfin.com>
	<32705.1409149899@warthog.procyon.org.uk>
	<CANP1eJFOw+2etaocge_h4tj7wigjNpcD0KsNW41pWaXFdToyDQ@mail.gmail.com>
	<CANP1eJEJG-f1i=4tntOxfdz1wy5RCUVm=M-1oB5k=k8uyADVYg@mail.gmail.com>
	<32201.1410985387@warthog.procyon.org.uk>
Date: Wed, 17 Sep 2014 16:24:50 -0400
Message-ID: <CANP1eJFiJxh39vPCG-8xo9NMZZw+xK8NyScYTB07nfRdeT5zMg@mail.gmail.com>
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

On Wed, Sep 17, 2014 at 4:23 PM, David Howells <dhowells@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> David, I know you're busy with other things. Would you like me to
>> re-spin the cleaned patches for you as a pull requests so you try to
>> get this upstream. I really want to see those fixes make it into
>> upstream.
>
> I've sent them Linuswards.
>
> David

I saw that in my inbox earlier. Thank you for taking care of it.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
