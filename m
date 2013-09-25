Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3IYUXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:23:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37591 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3IYUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:23:28 -0400
Date: Wed, 25 Sep 2013 21:23:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Holler <holler@ahsoftware.de>, Joe Perches <joe@perches.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Andy Whitcroft <apw@shadowen.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
Message-ID: <20130925202322.GB13318@ZenIV.linux.org.uk>
References: <1380047934.3575.100.camel@joe-AO722>
 <20130925152432.GY13318@ZenIV.linux.org.uk>
 <1380123344.17366.5.camel@joe-AO722>
 <20130925161949.GZ13318@ZenIV.linux.org.uk>
 <1380136920.17366.15.camel@joe-AO722>
 <20130925193035.GA11905@thunk.org>
 <1380138515.17366.22.camel@joe-AO722>
 <52433F89.5050104@ahsoftware.de>
 <20130925130352.0e89fd9439eff93c69cdcc32@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925130352.0e89fd9439eff93c69cdcc32@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 01:03:52PM -0700, Andrew Morton wrote:
> On Wed, 25 Sep 2013 21:54:49 +0200 Alexander Holler <holler@ahsoftware.de> wrote:
> 
> > Am 25.09.2013 21:48, schrieb Joe Perches:
> > 
> > > As I've said multiple times, checkpatch is a stupid
> > > little tool that can be ignored by anyone with
> > > different tastes.
> > 
> > Just that this isn't true for ordinary innocent people posting patches.
> 
> Nobody uses --strict.  Discussion is silly.

That it is, but you are mistaken about nobody using --strict; I've been
amused a while ago by a patch (duly forwarded to Dave Null for processing,
of course) that "fixed" something like goto Efault, in I don't remember
which file ;-)
