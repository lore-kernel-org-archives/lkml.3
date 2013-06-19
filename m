Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab3FSS73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:59:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59505 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab3FSS71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:59:27 -0400
Date: Wed, 19 Jun 2013 14:59:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>, Dave Chinner <dchinner@redhat.com>,
        Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with the ext4 tree
Message-ID: <20130619185917.GC24587@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Glauber Costa <glommer@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dave Chinner <dchinner@redhat.com>,
	Glauber Costa <glommer@openvz.org>
References: <20130619172721.00e757acd76e1f9d362f59be@canb.auug.org.au>
 <20130619074402.GC1990@localhost.localdomain>
 <20130619142031.GC24194@thunk.org>
 <20130619100635.72acbd05.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619100635.72acbd05.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:06:35AM -0700, Andrew Morton wrote:
> 
> Merge the ext4 change early, please.  The core shrinker changes aren't
> 100% certain at this time - first they need to stop oopsing ;)

Ack, sounds like a plan.

Are they oopsing often enough that they are likely to interfere with
running regression tests on linux-next?

					- Ted
