Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaGVHFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:05:36 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52586 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaGVHFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:05:35 -0400
Date: Tue, 22 Jul 2014 08:05:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Fix false positive MISSING_BREAK warnings
 with --file
Message-ID: <20140722070530.GB28529@lee--X1>
References: <20140721113948.GX30888@lee--X1>
 <1405948406.21586.10.camel@joe-AO725>
 <20140721132116.GZ30888@lee--X1>
 <1405952929.27900.7.camel@joe-AO725>
 <20140721143013.11ec351d47a9f822313247d2@linux-foundation.org>
 <1405984193.30871.10.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405984193.30871.10.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Joe Perches wrote:
> Using --file mode can give false positives with MISSING_BREAK
> fall-through warnings on simple but long multiple consecutive
> case statements.
> 
> Look for all lines before a case statement for a switch
> or a statement when using --file mode.
> 
> Fix a misspelling of preceded while there.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Reported-by: Lee Jones <lee.jones@linaro.org>

Solution works for me.

> total: 0 errors, 0 warnings, 574 lines checked
> 
> drivers/mfd/tps80031.c has no obvious style problems and is ready
> for submission.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
