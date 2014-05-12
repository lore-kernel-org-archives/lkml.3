Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbaELQQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:16:22 -0400
Received: from 1wt.eu ([62.212.114.60]:34940 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaELQQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:16:19 -0400
Date: Mon, 12 May 2014 18:16:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jon Maloy <jon.maloy@ericsson.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ying Xue <ying.xue@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 072/143] tipc: fix lockdep warning during bearer initialization
Message-ID: <20140512161613.GD19173@1wt.eu>
References: <20140512003203.627061916@1wt.eu> <5370F0F0.1020606@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5370F0F0.1020606@ericsson.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 12:04:00PM -0400, Jon Maloy wrote:
> This one is obsolete.
> tipc_net_lock does not exist in the current code. It was removed in commit
>  7216cd949c9bd56a4ccd952c624ab68f8c9aa0a4("tipc: purge tipc_net_lock lock")

I'm a bit confused, I can't find this commit, in what branch is it ?

Thanks,
Willy

