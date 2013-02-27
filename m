Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795Ab3B0T1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:27:13 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46704 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab3B0T1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:27:12 -0500
Message-ID: <512E5E09.1040605@gmail.com>
Date: Thu, 28 Feb 2013 03:27:05 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zheng Liu <wenqing.lz@taobao.com>, Borislav Petkov <bp@alien8.de>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.9
References: <20130227153435.GB5609@thunk.org> <20130227154450.GA23402@x4> <20130227170157.GA222@x4> <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com> <20130227172256.GA236@x4> <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com> <20130227174553.GA224@x4> <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com> <20130227184912.GA19624@thunk.org> <20130227185625.GA224@x4> <20130227191923.GA1121@redhat.com>
In-Reply-To: <20130227191923.GA1121@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 03:19 AM, Dave Jones wrote:
> On Wed, Feb 27, 2013 at 07:56:25PM +0100, Markus Trippelsdorf wrote:
>  > On 2013.02.27 at 13:49 -0500, Theodore Ts'o wrote:
>  > 
>  > > Markus, Dave, can you confirm that this fixes your problem?
>  > 
>  > Yes, it fixes the issue.
> 
> Looks like it's fixed here too.
> 
> How did this make it through -next without anyone hitting it ?

Sorry, my apology.

> 
> I can't remember how many years ago I last bought a disk < 1TB,
> and I can't be alone.  Or is everyone all about SSDs these days?

I admit that I run xfstests on a SSD that has 128G.

> 
> Is anyone running xfstests or similar on linux-next regularly ?

Ted has a dev branch for -next, and I work on this branch.

Regards,
						- Zheng
