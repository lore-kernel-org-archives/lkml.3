Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3ILOgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:36:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47672 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3ILOgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:36:40 -0400
Message-ID: <5231D166.1060905@kernel.dk>
Date: Thu, 12 Sep 2013 08:36:22 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Shaohua Li <shli@fusionio.com>
Subject: Re: [PATCH 0/3] blk-mq: Avoid effects of a weird queue depth
References: <cover.1375451955.git.agordeev@redhat.com> <20130912074202.GA8041@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20130912074202.GA8041@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 01:42 AM, Alexander Gordeev wrote:
> Hi Jens,
> 
> Could you consider patches 4 and 5, please?

Added. Really should be re-folded since the previous patches were
broken, but I'll do that some time anyway for parts of the series again.

-- 
Jens Axboe

