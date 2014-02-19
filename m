Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaBSIwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:52:47 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:43868 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaBSIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:52:45 -0500
Message-ID: <530470E4.2040104@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 09:52:52 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Yuan Pengfei <coolypf@qq.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gcov: fix memory allocation problem in gcov_info_dup
References: <tencent_074552B42B4D25D2329613D8@qq.com>
In-Reply-To: <tencent_074552B42B4D25D2329613D8@qq.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021908-8372-0000-0000-000008B718AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.02.2014 08:06, Yuan Pengfei wrote:
> From: Yuan Pengfei <coolypf@qq.com>
> 
> If -fprofile-values option is used, ctr->num and sci_ptr->num
> may be zero, resulting in zero size and cv_size, which will
> cause ENOMEM when opening gcov data files in debugfs.
> Signed-off-by: Yuan Pengfei <coolypf@qq.com>

I'm unaware of any user of -fprofile-values in the kernel. Are you
trying to extend gcov-kernel to also support -fprofile-values? I would
expect that additional changes to the .gcda file creation logic are
required to fully support this GCC option.


Regards,
  Peter Oberparleiter

-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

