Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaBTIwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:52:22 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:36260 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaBTIwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:52:20 -0500
Message-ID: <5305C249.3080502@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 09:52:25 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Yuan Pengfei <coolypf@qq.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gcov: fix memory allocation problem in gcov_info_dup
References: <tencent_074552B42B4D25D2329613D8@qq.com> <530470E4.2040104@linux.vnet.ibm.com> <tencent_791B676E6E166A343D8CB154@qq.com>
In-Reply-To: <tencent_791B676E6E166A343D8CB154@qq.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022008-0342-0000-0000-000007DA7524
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.02.2014 11:38, Yuan Pengfei wrote:
> Using -fprofile-values is one case that will cause the memory allocation
> problem. More changes are needed to fully support -fprofile-values. I
> submit this patch first because I think it is obvious and does no harm.
>> I'm unaware of any user of -fprofile-values in the kernel. Are you
>> trying to extend gcov-kernel to also support -fprofile-values? I would
>> expect that additional changes to the .gcda file creation logic are
>> required to fully support this GCC option.

If there is a way to trigger the problem of gcov_info.values == NULL
using the existing gcov-kernel infrastructure then I agree that this
should be fixed. If not, then I would rather see the suggested change as
part of a patch series that enables other profiling types.

-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

