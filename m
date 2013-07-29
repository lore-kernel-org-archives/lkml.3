Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3G2QJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:09:53 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:36268 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3G2QJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:09:51 -0400
Message-ID: <51F63F12.6070300@hp.com>
Date: Mon, 29 Jul 2013 10:08:18 +0000
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, T Makphaibulchoke <tmac@hp.com>,
        viro@zeniv.linux.org.uk, adilger.kernel@dilger.ca,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, tmakph@gmail.com, aswin@hp.com
Subject: Re: [PATCH 0/2] ext4: increase mbcache scalability
References: <1374108910-50444-1-git-send-email-tmac@hp.com> <20130718163024.GA12727@thunk.org> <20130718163301.GB12727@thunk.org>
In-Reply-To: <20130718163301.GB12727@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 04:33 PM, Theodore Ts'o wrote:
> On Thu, Jul 18, 2013 at 12:30:24PM -0400, Theodore Ts'o wrote:
>> On Wed, Jul 17, 2013 at 06:55:10PM -0600, T Makphaibulchoke wrote:
>>> This patch intends to improve the scalability of an ext4 filesystem by
>>> introducing higher degree of parallelism to the usages of its mb_cache and
>>> mb_cache_entries.
>>>
>>> ...
>>>
>>>  fs/ext4/ext4.h          |   1 +
>>>  fs/ext4/super.c         |   8 ++
>>>  fs/ext4/xattr.c         |  41 +++++---
>>>  fs/ext4/xattr.h         |   3 +
>>>  fs/mbcache.c            | 432 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
>>>  include/linux/mbcache.h |   5 +
>>>  6 files changed, 385 insertions(+), 105 deletions(-)
>>>
>>
>> I see the diff stats, but there was no patch attached to your message.
>> Could you please resend the patch to the linux-ext4 list?
> 
> Never mind, I see them now.  I didn't notice this was a 0/2 message,
> and since you are apparently using an old versio of git which doesn't
> enable --thread by default (or you have a git config setting which
> disables the use of mail threading), I didn't see the patches chained
> to the message.
> 
> Sorry for being confused,
> 
> 						- Ted
> 
Hi Ted,

Could you please let me know if you have comment, suggestion or feedback for the patch.  Thanks in advance.

Thanks,
Mak.

