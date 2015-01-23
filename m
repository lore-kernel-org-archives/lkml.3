Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbbAWWQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:16:51 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:37432 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbAWWQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:16:48 -0500
Message-ID: <54C2C836.2010300@ahsoftware.de>
Date: Fri, 23 Jan 2015 23:16:22 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: overwrite keys with zero before deleting them
References: <1421976009-9819-1-git-send-email-holler@ahsoftware.de>	<1422050221-28345-1-git-send-email-holler@ahsoftware.de> <CAFLxGvwQVKaB_MTpJ9LPNvY6bO_-_qCf7PYQuDrF4Q+4e3oUnQ@mail.gmail.com>
In-Reply-To: <CAFLxGvwQVKaB_MTpJ9LPNvY6bO_-_qCf7PYQuDrF4Q+4e3oUnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.01.2015 um 23:06 schrieb Richard Weinberger:
> On Fri, Jan 23, 2015 at 10:57 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>> This is for the more paranoid people, also it's
>> questionable what paranoid nowadays means.
> 
> Isn't this complete useless when modern filesystems like btrfs or
> storage devices like SSDs are used?

On SSDs it's likely useless, unfortunately. In regard to filesystems it
depends (how knows what thay all do?). But it doesn't cost anything and
might still be worth to use on conventional harddisks with several
filesystems.

I would like to have a secure-delete for FLASH based drives, but I
assume it will need some time until someone established something like
secure-trim and a userspace utility will be available.

Regards,

Alexander Holler
