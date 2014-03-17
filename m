Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbaCQKPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:15:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56288 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaCQKPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:15:43 -0400
Date: Mon, 17 Mar 2014 11:15:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, vegard.nossum@oracle.com,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Vegard Nossum <vegard.nossum@gmail.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: kmemcheck: OS boot failed because NMI handlers access the memory
 tracked by kmemcheck
Message-ID: <20140317101527.GB27965@twins.programming.kicks-ass.net>
References: <5326BE25.9090201@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5326BE25.9090201@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 05:19:33PM +0800, Xishi Qiu wrote:
> Now we don't support page faults in NMI context is that we
> may already be handling an existing fault (or trap) when the NMI hits.
> So that would mess up kmemcheck's working state.

I think it was suggested earlier that kmemcheck could maybe have a stack
of states.
