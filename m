Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaDHPWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:22:17 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:39125 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaDHPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:22:16 -0400
MIME-Version: 1.0
In-Reply-To: <53440A5D.6050301@zytor.com>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
	<53440A5D.6050301@zytor.com>
Date: Tue, 8 Apr 2014 08:22:15 -0700
X-Google-Sender-Auth: 6E1vH5nqOlQhdw0jIdHLmLo_ox0
Message-ID: <CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mel Gorman <mgorman@suse.de>, Linux-X86 <x86@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 7:40 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> David, is your patchset going to be pushed in this merge window as expected?

Apparently aiming for 3.16 right now.

> That being said, these bits are precious, and if this ends up being a
> case where "only Xen needs another bit" once again then Xen should
> expect to get kicked to the curb at a moment's notice.

Quite frankly, I don't think it's a Xen-only issue. The code was hard
to figure out even without the Xen issues. For example, nobody ever
explained to me why it

 (a) could be the same as PROTNONE on x86
 (b) could not be the same as PROTNONE in general

I think the best explanation for it so far was from the little voices
in my head that sang "It's a kind of Magic", and that isn't even
remotely the best song by Queen.

              Linus
