Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3J1OGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:06:25 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:53745 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3J1OGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:06:24 -0400
Message-ID: <526E6F58.8040405@synopsys.com>
Date: Mon, 28 Oct 2013 19:36:16 +0530
From: Vineet Gupta <vineetg76@gmail.com>
Organization: Synopsys
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: export symbol for save_stack_trace() in
 stacktrace.c
References: <526DD356.5020101@asianux.com>
In-Reply-To: <526DD356.5020101@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 08:30 AM, Chen Gang wrote:
> Need export its symbol just like other architectures done, or can not
> pass compiling with allmodconfig, the related error:
> 
>     MODPOST 2994 modules
>   ERROR: "save_stack_trace" [kernel/backtracetest.ko] undefined!
>   ERROR: "save_stack_trace" [drivers/md/persistent-data/dm-persistent-data.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Applied for 3.13

Thx,
-Vineet
