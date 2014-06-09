Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbaFINTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:19:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239AbaFINS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:18:56 -0400
Date: Mon, 9 Jun 2014 16:19:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vhost tree
Message-ID: <20140609131920.GA5048@redhat.com>
References: <20140603183838.6af4c0a5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603183838.6af4c0a5@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 06:38:38PM +1000, Stephen Rothwell wrote:
> Hi Michael,
> 
> After merging the vhost tree, today's linux-next build (powerpc allyesconfig)
> failed like this:

Yes pushed a wrong tree, sorry about that.
I fixed it up now, sorry about the noise.

