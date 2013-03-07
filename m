Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab3CGF2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 00:28:05 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55112 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3CGF2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 00:28:03 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-b1-513825602d2f
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf, tools: Define MADV_*HUGEPAGE for old kernels
References: <1362611957-4358-1-git-send-email-andi@firstfloor.org>
Date: Thu, 07 Mar 2013 14:28:00 +0900
In-Reply-To: <1362611957-4358-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Wed, 6 Mar 2013 15:19:16 -0800")
Message-ID: <87sj47rd7j.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed,  6 Mar 2013 15:19:16 -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Avoids this on RHEL6:
>
> bench/numa.c: In function ‘alloc_data’:
> bench/numa.c:334: error: ‘MADV_HUGEPAGE’ undeclared (first use in this function)
> bench/numa.c:334: error: (Each undeclared identifier is reported only once
> bench/numa.c:334: error: for each function it appears in.)
> bench/numa.c:341: error: ‘MADV_NOHUGEPAGE’ undeclared (first use in this function)

The fix was posted already but there's an issue also.  Please see

  https://lkml.org/lkml/2013/3/6/2

Thanks,
Namhyung
