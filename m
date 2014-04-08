Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbaDHSz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:55:58 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:57986 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779AbaDHSzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140408185146.GP7292@suse.de>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
	<53440A5D.6050301@zytor.com>
	<CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
	<20140408164652.GL7292@suse.de>
	<CA+55aFwrwYmWFXWpPeg-keKukW0=dwvmUBuN4NKA=JcseiUX3g@mail.gmail.com>
	<20140408185146.GP7292@suse.de>
Date: Tue, 8 Apr 2014 11:55:22 -0700
X-Google-Sender-Auth: XqtRobPpFeeWWNfBDJc8kZzistQ
Message-ID: <CA+55aFwXuwE8=4h2LrjfjjMhE35pj4W6oOXYFuWkkB65eya=XA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
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

On Tue, Apr 8, 2014 at 11:51 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> I picked a solution. The posted series uses a different bit.

Yes, and I actually like that. I have nothing against your patch
series. I'm ranting and raving because you then seemed to say "maybe
we shouldn't pick a solution after all" when you said:

> > If you are ok with leaving _PAGE_NUMA as _PAGE_PROTNONE

which was what I reacted to.

             Linus
