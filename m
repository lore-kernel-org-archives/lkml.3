Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaG2Pf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:35:28 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58714 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaG2Pf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <28563.1406647922@warthog.procyon.org.uk>
References: <cover.1406043029.git.milosz@adfin.com>
	<53CE885C.4070302@adfin.com>
	<28563.1406647922@warthog.procyon.org.uk>
Date: Tue, 29 Jul 2014 11:35:24 -0400
Message-ID: <CANP1eJFZyZ6X-EaGb6ap911YoF4A63T0o9XUoFAMaEn1OFVX3Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] FS-Cache: Timeout for releasepage()
From: Milosz Tanski <milosz@adfin.com>
To: David Howells <dhowells@redhat.com>
Cc: "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Shantanu Goel <sgoel01@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally I was planning doing something with that (a debug message)
but I decided against it and forgot to remove it.

Neil Brown came up with a very similar solution that he posted as I
was developing my own. His patch might be a better candidate.

- M

On Tue, Jul 29, 2014 at 11:32 AM, David Howells <dhowells@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> +bool relase_page_wait_timeout(struct fscache_cookie *cookie, struct page *page
>
> I presume you mean "release_page_wait_timeout".
>
> Also, the new function returns a value which you then ignore.  Should you do
> something with it?
>
> David



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
