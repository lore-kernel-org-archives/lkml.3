Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbaKSUu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:50:58 -0500
Received: from fieldses.org ([174.143.236.118]:55585 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbaKSUu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:50:57 -0500
Date: Wed, 19 Nov 2014 15:50:56 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: bad commit in the nfsd tree
Message-ID: <20141119205056.GB14207@fieldses.org>
References: <20141119080411.09f6a811@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119080411.09f6a811@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 08:04:11AM +1100, Stephen Rothwell wrote:
> Hi,
> 
> I just noticed that the top commit of the nfsd tree (be603bbb7bc1
> "OOPS") has no Signed-off-by tags (or a real commit message at all) ...

Yes, sorry, I needed it as a temporary fix for a client-side bug (since
gone upstream) for my testing, but didn't mean for it to leak out.
Should be gone now.

--b.
