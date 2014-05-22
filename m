Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaEVQwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:52:11 -0400
Received: from tex.lwn.net ([70.33.254.29]:46087 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbaEVQwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:52:08 -0400
Date: Thu, 22 May 2014 10:52:06 -0600
From: Jake Edge <jake@lwn.net>
To: Anton Saraev <antonysaraev@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/3] staging/skein: more cleanup
Message-ID: <20140522105206.0115e1a4@chukar.edge2.net>
In-Reply-To: <20140520215217.GB1692@Ruffial>
References: <20140520075612.220a13ae@chukar.edge2.net>
	<20140520144757.GA8664@titan.lakedaemon.net>
	<20140520102411.413d565d@chukar.edge2.net>
	<20140520215217.GB1692@Ruffial>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 01:52:17 +0400 Anton Saraev wrote:
> On Tue, May 20, 2014 at 10:24:11AM -0600, Jake Edge wrote:
> > On Tue, 20 May 2014 10:47:57 -0400 Jason Cooper wrote:
> >
> > but some kind of tests are needed to ensure nothing breaks before
> > digging into that ...
> 
> I have some test: slightly modified version of tests from
> https://github.com/wernerd/Skein3Fish. It works as debugfs entry
> and require some modification needed for module support
> ("public" function must be extern). As I can understand Jason
> has his own tests. That would be logical to share them but
> I don't know where.

well, it seems to me that we want tests that eventually can be added
into the crypto test framework once skein moves out of staging and into
crypto ... Jason's objdiff seems like it would be used as another
development tool ...

so do you have your tests anywhere that we can look at them?  or,
failing that, maybe you can just email me a copy off-list or something?

do you have patches pending for skein?  i might get a chance to hack on
this some over the weekend, and we may as well try to avoid duplicating
each other's efforts ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
