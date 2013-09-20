Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3ITSfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:35:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44910 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3ITSf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:35:28 -0400
Date: Fri, 20 Sep 2013 14:35:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: old trees
Message-ID: <20130920183517.GH5707@phenom.dumpdata.com>
References: <20130917170124.0afa2e103a9977355ad7c72c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917170124.0afa2e103a9977355ad7c72c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 05:01:24PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> This message is bcc'd to each of the contacts for the trees listed below,
> so apologies if you get two copies.
> 
> I have been inspired to check the ages of the trees included in
> linux-next.  Below I have listed all the trees that have not been
> commited to in the past 6 months.  Please let me know if the tree is not
> longer in use.  I don't mind keeping these trees in linux-next if they
> will have continued use, but would like to remove any that are no longer
> needed.

Thank you for the prunning effort.


> ibft		1 year, 9 months ago

Can go away.

> swiotlb		11 months ago

Need it. Don't remove it pls.

> tmem		11 months ago

Can go away.
