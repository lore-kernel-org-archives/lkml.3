Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaCGRJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:09:38 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:38947 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbaCGRJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:09:37 -0500
Date: Fri, 7 Mar 2014 11:09:34 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Josh Cartwright <joshc@codeaurora.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
Subject: Re: [PATCH -next] slub: Replace __this_cpu_inc usage w/ SLUB_STATS
In-Reply-To: <20140306182941.GH18529@joshc.qualcomm.com>
Message-ID: <alpine.DEB.2.10.1403071108310.21846@nuc>
References: <20140306194821.3715d0b6212cc10415374a68@canb.auug.org.au> <20140306155316.GG18529@joshc.qualcomm.com> <20140306182941.GH18529@joshc.qualcomm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Josh Cartwright wrote:

> Although, I'm wondering how exact these statistics need to be.  Is
> making them preemption safe even a concern?

Not sure about that. You solution makes it preempt safe. If is can be
tolerated that its racy then raw_cpu_inc() could be used.
