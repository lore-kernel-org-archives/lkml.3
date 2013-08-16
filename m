Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3HPKYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:24:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44341 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab3HPKW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:22:26 -0400
Message-Id: <20130816101221.028189677@chello.nl>
User-Agent: quilt/0.60-1
Date: Fri, 16 Aug 2013 12:12:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/6] Various load-balance cleanups/optimizations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first 3 are reworks of the patches Joonsoo posted with fixes/changes, the
second three are further cleanups that I spotted while working on the patches
from Joonsoo.

There was enough wrong with the patches from Joonsoo that I feel somewhat
hesitant to merge them now and request people to stare at them in detail to
make sure there's no other weird stuff I've missed.

Thanks.


