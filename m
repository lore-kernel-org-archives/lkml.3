Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaLHUDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:03:00 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34898 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751794AbaLHUC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:02:59 -0500
Date: Mon, 8 Dec 2014 14:02:57 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
        George Beshers <gbeshers@sgi.com>, Russ Anderson <rja@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Fix KMALLOC_MAX_SIZE overflow during cpumask allocation
Message-ID: <20141208200257.GD4182@sgi.com>
References: <1417540664-51393-1-git-send-email-athorlton@sgi.com>
 <20141208104214.GA22066@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141208104214.GA22066@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 11:42:14AM +0100, Ingo Molnar wrote:
> This patch fails to build with certain configs:
> 
> kernel/sched/core.c:7130:33: error: incompatible types when assigning to type ‘cpumask_var_t’ from type ‘void *’

Thanks for letting us know, Ingo.  I believe George has something in
mind to fix this.  We'll take a look and get another version out ASAP!

- Alex
