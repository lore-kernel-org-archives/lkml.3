Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3FQVMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:12:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:57813 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab3FQVMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,883,1363158000"; 
   d="scan'208";a="351294645"
Message-ID: <51BF7BAA.5030803@intel.com>
Date: Mon, 17 Jun 2013 14:12:10 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
Subject: Re: ext4 extent status tree LRU locking
References: <51B7B128.60909@intel.com> <20130614140940.GA20401@gmail.com> <20130614140215.GA1017@thunk.org> <20130614170028.GA21544@gmail.com> <20130614180054.GB1017@thunk.org> <20130617101033.GA17828@gmail.com>
In-Reply-To: <20130617101033.GA17828@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 03:10 AM, Zheng Liu wrote:
> Dave, that would be great if you could do your testing again to confirm
> this patch is useful.

I was able to apply this to Ted's

	https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/

"ext4/dev" tree with a bit of fuzz.  What did you generate this against,
btw?

It does seem to be functioning OK for me, and passes the other tests
that saw so much spinlock contention previously.  You can add my
Tested-by if you like.
