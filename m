Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbbAXAOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:14:04 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:43331 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbAXAN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:13:59 -0500
Message-ID: <54C2E3AB.9000008@ahsoftware.de>
Date: Sat, 24 Jan 2015 01:13:31 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: overwrite keys with zero before deleting them
References: <1422050221-28345-1-git-send-email-holler@ahsoftware.de> <1421976009-9819-1-git-send-email-holler@ahsoftware.de> <6705.1422057490@warthog.procyon.org.uk>
In-Reply-To: <6705.1422057490@warthog.procyon.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.01.2015 um 00:58 schrieb David Howells:
> Alexander Holler <holler@ahsoftware.de> wrote:
> 
>> This is for the more paranoid people, also it's
>> questionable what paranoid nowadays means.
> 
> shred?

Seems to do the same like when using dd, just that it does it moultiple
times.

And according to an article I've read some years ago, overwrriting a
blocks on harddisks multiple times doesn't really make sense because
doing it just once is enough (the necessity to do it multiple times
seems to have been one of these unexplainable myths in the IT) .

So I've no idea if it's worth to use shred and have no idea if it's part
of any GNU/Linux system (seems likely as it it's part of coreutils), how
it's maintained and how long it will be available.

But if requested, I will replace that dd with shred or just feel free to
do it yourself.

Regards,

Alexander Holler
