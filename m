Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3FSRGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:06:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3FSRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:06:54 -0400
Date: Wed, 19 Jun 2013 10:06:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Glauber Costa <glommer@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>, Dave Chinner <dchinner@redhat.com>,
        Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with the ext4 tree
Message-Id: <20130619100635.72acbd05.akpm@linux-foundation.org>
In-Reply-To: <20130619142031.GC24194@thunk.org>
References: <20130619172721.00e757acd76e1f9d362f59be@canb.auug.org.au>
	<20130619074402.GC1990@localhost.localdomain>
	<20130619142031.GC24194@thunk.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013 10:20:31 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:

> Is there some way we can avoid this conflict during the next merge
> window?  Given that this is an API change, it may not be possible.
> Failing that, what's the best merge strategy; should we try to make
> sure your change goes first, and then I can defer the ext4 pull
> request until a little bit later in the merge window?

Merge the ext4 change early, please.  The core shrinker changes aren't
100% certain at this time - first they need to stop oopsing ;)
