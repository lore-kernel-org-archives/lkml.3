Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158Ab3D3RcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:32:17 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:26379 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170Ab3D3RcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:32:14 -0400
Message-ID: <1367343132.1784.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 3.8-stable] lib/int_sqrt.c: optimize square root
 algorithm
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Date: Tue, 30 Apr 2013 10:32:12 -0700
In-Reply-To: <006d01ce4577$a762ae10$f6280a30$%choi@samsung.com>
References: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
	 <006d01ce4577$a762ae10$f6280a30$%choi@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 16:52 +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?
> 

I don't see this as a candidate for stable. Its just an optimization and
doesn't address any existing issue.

Thanks,
Davidlohr

