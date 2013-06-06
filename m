Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3FFR7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:59:24 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:54496 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3FFR7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:59:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130606175529.GT14762@redacted.bos.redhat.com>
References: <20130606170557.GQ14762@redacted.bos.redhat.com>
	<51B0C9E5.7030105@suse.cz>
	<20130606175529.GT14762@redacted.bos.redhat.com>
Date: Thu, 6 Jun 2013 13:59:21 -0400
Message-ID: <CA+5PVA4uNNSXcJHZfoyEmqMsCwK6hC7e2ziSdz5TNXwiiUQ7CQ@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: pass headers to headers_install.sh on stdin
From: Josh Boyer <jwboyer@gmail.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 1:55 PM, Kyle McMartin <kyle@redhat.com> wrote:
> On Thu, Jun 06, 2013 at 07:41:57PM +0200, Michal Marek wrote:
>> Dne 6.6.2013 19:05, Kyle McMartin napsal(a):
>> > While using make V=1 to test some things, I noticed on our builders that
>> > headers_install was failing because the argument list to /bin/sh was too
>> > long. Working around it is slightly kludgy...
>>
>> This is already fixed with
>>
>>
>> commit c0ff68f1611d6855a06d672989ad5cfea160a4eb
>> Author: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> Date:   Mon Apr 29 14:15:51 2013 +0200
>>
>>     kbuild: fix make headers_install when path is too long
>>
>>
>> in linux-next.
>>
>
> OK, I guess.

Wait... not OK.  This is broken now.  People are clearly having to fix
it again and wasting their time because a fix is already available.
Why is a fix for it sitting in linux-next?  Please get that fix into
Linus' tree.

josh
