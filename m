Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809AbaDIPgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129AbaDIPgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:36:12 -0400
Message-ID: <1397057742.31272.30.camel@deneb.redhat.com>
Subject: Re: [PATCH 10/31] arch,c6x: Convert smp_mb__*
From: Mark Salter <msalter@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com
Date: Wed, 09 Apr 2014 11:35:42 -0400
In-Reply-To: <20140319065204.317916607@infradead.org>
References: <20140319064729.660482086@infradead.org>
	 <20140319065204.317916607@infradead.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 07:47 +0100, Peter Zijlstra wrote:
> c6x doesn't have a barrier.h and completely relies on
> asm-generic/barrier.h. Therefore its smp_mb() is barrier() and we can
> use the default versions that are smp_mb().
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---

Acked-by: Mark Salter <msalter@redhat.com>


