Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3DMQsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 12:48:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43387 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3DMQsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 12:48:40 -0400
Subject: Re: helping with tracking commits across repos
From: Vinod Koul <vkoul@infradead.org>
To: dmg@uvic.ca
Cc: vinod.koul@intel.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Apr 2013 21:48:55 +0530
Message-ID: <1365869935.2348.15.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 13:22 -0700, D M German wrote:
> Hi Everybody,
> 
> I am professor of computer science at the University of Victoria
> (Canada).
> 
> During the last year and a half, we have been trying to track the
> commits as they move in the entire linux git repos ecosystem. We have
> amassed a good amount of data that tell us for every commit (and in fact
> for every unique patch inside a commit) where it has been and whether it
> has reached linus or not ---or any other repository, as a matter of
> fact.
i see some of the commits shown not in linus tree, although they are...
perhaps a bug?
http://o.cs.uvic.ca:20810/perl/cid.pl?cid=765024697807ad1e1cac332aa891253ca4a339da

It shows the same for linus's merge!
http://o.cs.uvic.ca:20810/perl/cid.pl?cid=cfb63bafdb87bbcdc5d6dbbca623d3f69475f118

-- 
Vinod Koul
Intel Corp.

