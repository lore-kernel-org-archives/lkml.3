Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab3GPCon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:44:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50943 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3GPCom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:44:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130715193224.dbbbfb02.akpm@linux-foundation.org>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
 <1373908589.2062.18.camel@joe-AO722> <20130715184030.GA17220@kroah.com>
 <20130715121357.42ef2826750909c1fc57788a@linux-foundation.org>
 <20130716000755.GC26261@kroah.com> <CA+a=Yy6cC9rYcmAka2652UhJFse9eVfOtfg96SiObBiwsw+zQQ@mail.gmail.com>
 <20130715193224.dbbbfb02.akpm@linux-foundation.org>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 16 Jul 2013 10:44:20 +0800
Message-ID: <CA+a=Yy4cA9dmbNqPXDZR0wHcSbOc4Die=r+8cb-Zn7OV=1M-sw@mail.gmail.com>
Subject: Re: [PATCH-v3 00/17] staging/lustre: fix various build issues
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:32 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> erk, I forgot about that.
>
> Please send Greg a full patchset against current Linus mainline.  Then,
> ideally, send me the patches which adapt that patchset to the new
> shrinker API.
>
> Or don't worry about the second part and I'll fix things up at my end.

The v3 patchset applies cleanly against current Linus mainline. Greg
please merge them if they are OK to you.

Andrew please just drop the fifth patch of the five. It is included in
the patchset sent to Greg. The other four are shrinker API patches and
can be applied cleanly. There is no conflict between the two patchsets
except for the fifth one ([patch 5/5] staging/lustre: replace
num_physpages with totalram_pages) that appears in both.

Thanks,
Tao
