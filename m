Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaLCQnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:43:13 -0500
Received: from tex.lwn.net ([70.33.254.29]:36605 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaLCQnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:43:11 -0500
Date: Wed, 3 Dec 2014 11:43:08 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: SeongJae Park <sj38.park@gmail.com>
Cc: tj@kernel.org, lizefan@huawei.com, trivial@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cgroups: Documentation: fix trivial typos and wrong
 paragraph numberings
Message-ID: <20141203114308.3898e74e@lwn.net>
In-Reply-To: <alpine.DEB.2.10.1412040033120.1819@hxeon>
References: <1417607625-2775-1-git-send-email-sj38.park@gmail.com>
	<1417607625-2775-2-git-send-email-sj38.park@gmail.com>
	<20141203090113.359198f6@lwn.net>
	<alpine.DEB.2.10.1412040033120.1819@hxeon>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 00:36:09 +0900 (KST)
SeongJae Park <sj38.park@gmail.com> wrote:

> I based it on latest linux-next tree.
> 
> Looks like I should based it on linux-docs tree. I will do for my later 
> patches for documentations.
> 
> Below is the patch 2 based on linux-docs tree.

Thanks, but the best thing to do might be to have Andrew Morton take the
original patch. His tree already contains the other changes to that file;
keeping things there will help to avoid conflicts and dependencies during
the merge window.

Thanks,

jon
