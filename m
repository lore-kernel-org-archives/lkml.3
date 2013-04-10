Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935760Ab3DJIv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:51:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3DJIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:51:26 -0400
Message-ID: <1365583873.30071.31.camel@laptop>
Subject: Re: [PATCH] sched: wake-affine throttle
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Wed, 10 Apr 2013 10:51:13 +0200
In-Reply-To: <5164DCE7.8080906@linux.vnet.ibm.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:30 +0800, Michael Wang wrote:
> | 15 GB   |      32 | 35918 |   | 37632 | +4.77% | 47923 | +33.42% |
> 52241 | +45.45%

So I don't get this... is wake_affine() once every milisecond _that_
expensive?

Seeing we get a 45%!! improvement out of once every 100ms that would
mean we're like spending 1/3rd of our time in wake_affine()? that's
preposterous. So what's happening?



