Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3CKWPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:15:38 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:54216 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3CKWPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130311141032.7c0fa60279fa172b72fc0bf7@linux-foundation.org>
References: <20130306222412.1255.81929.stgit@warthog.procyon.org.uk>
	<alpine.LRH.2.02.1303071558030.25164@tundra.namei.org>
	<20130311210211.GA13575@kroah.com>
	<20130311141032.7c0fa60279fa172b72fc0bf7@linux-foundation.org>
Date: Mon, 11 Mar 2013 15:15:36 -0700
X-Google-Sender-Auth: w_y8FwEFB7uQoFYh_XkFfEe2eWI
Message-ID: <CA+55aFwBXZn9QizRAHNWQXuj6vE1Z9jrMDKVtQmoFZUH=yRf5A@mail.gmail.com>
Subject: Re: [PATCH] KEYS: Fix race with concurrent install_user_keyrings()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, James Morris <jmorris@namei.org>,
        David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org,
        Petr Matousek <pmatouse@redhat.com>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mguzik@redhat.com, Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 2:10 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 11 Mar 2013 14:02:11 -0700 Greg KH <gregkh@linuxfoundation.org> wrote:
>
>> On Thu, Mar 07, 2013 at 03:59:09PM +1100, James Morris wrote:
>> > On Wed, 6 Mar 2013, David Howells wrote:
>> >
>> > > Reported-by: Mateusz Guzik <mguzik@redhat.com>
>> > > Signed-off-by: David Howells <dhowells@redhat.com>
>> >
>> > Acked-by: James Morris <james.l.morris@oracle.com>
>>
>> What happened to this patch?  I don't see it in Linus's tree, James, did
>> you pick it up?
>
> James has acked it.  I have it queued for processing so it isn't lost.
> It has no cc:stable's in it, but David always forgets that ;)

I usually expect that if the subsystem maintainer is involved, he's
the one to pick it up.

If James' ack was "Linus, please take this directly, I'm busy and have
nothing else pending", then I really would prefer to hear that exact
thing. Otherwise I'm just going to ignore the patch "safe" in the
knowledge that clearly the subsystem maintainer is aware of it.

             Linus
