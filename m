Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3GKAez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:34:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58739 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3GKAey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:34:54 -0400
X-AuditID: 9c930179-b7c49ae000000e68-73-51ddfdab4cb6
Date: Thu, 11 Jul 2013 09:34:54 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 06/23] tools lib lk: Fix for cross build
Message-ID: <20130711003453.GA7756@lge.com>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
 <1373483963-19277-7-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373483963-19277-7-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:19:06PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Currently, lib lk doesn't use CROSS_COMPILE environment variable, so
> cross build always fails.

Hello, Arnaldo.

Fix for lib lk cross build is already merged into mainline.
It may be from your tree :)
See following commit.

commit 3c4797d46c14fa0c7cf733a77bd4b28875078b53
Author: Rabin Vincent <rabin@rab.in>
Date:   Fri May 17 22:27:44 2013 +0200

    tools lib lk: Respect CROSS_COMPILE

    Make lk use CROSS_COMPILE, in order to be able to cross compile perf
    again.

    Signed-off-by: Rabin Vincent <rabin@rab.in>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Borislav Petkov <bp@suse.de>
    Link: http://lkml.kernel.org/r/1368822464-4887-1-git-send-email-rabin@rab.in
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Thanks.

> 
> This is a quick fix for this problem.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1371603750-15053-2-git-send-email-iamjoonsoo.kim@lge.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

