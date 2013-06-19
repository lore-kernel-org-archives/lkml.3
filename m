Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3FSOUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:20:44 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59399 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669Ab3FSOUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:20:42 -0400
Date: Wed, 19 Jun 2013 10:20:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Glauber Costa <glommer@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with the ext4 tree
Message-ID: <20130619142031.GC24194@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Glauber Costa <glommer@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Dave Chinner <dchinner@redhat.com>,
	Glauber Costa <glommer@openvz.org>
References: <20130619172721.00e757acd76e1f9d362f59be@canb.auug.org.au>
 <20130619074402.GC1990@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619074402.GC1990@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there some way we can avoid this conflict during the next merge
window?  Given that this is an API change, it may not be possible.
Failing that, what's the best merge strategy; should we try to make
sure your change goes first, and then I can defer the ext4 pull
request until a little bit later in the merge window?

Thanks,

				- Ted
