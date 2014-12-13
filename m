Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaLMSWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 13:22:44 -0500
Received: from syn.loicp.eu ([176.31.96.212]:52696 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaLMSWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 13:22:43 -0500
Date: Sat, 13 Dec 2014 19:22:38 +0100
From: Loic Pefferkorn <loic@loicp.eu>
To: Jeremiah Mahler <jmmahler@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, jun.j.tian@intel.com, octavian.purdila@intel.com,
        nnk@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: goldfish: Fix minor coding style
Message-ID: <20141213182238.GA6979@iron>
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
 <20141213175518.GA28616@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141213175518.GA28616@hudson.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Whose convention is this?  I can't find any mention in
> Documention/CodingStyle. checkpatch.pl doesn't complain about them.
> And there are almost three thousand examples in staging which don't
> use this convention.
> 
>   linux-next$ grep -r "== NULL" drivers/staging/* | wc -l
>   2844

Hi Jeremiah,

Thanks for your feedback.

I have used checkpatch.pl with the --strict flag:

$ ./scripts/checkpatch.pl --strict -f drivers/staging/goldfish/goldfish_nand.c
CHECK: Comparison to NULL could be written "!cps"
#51: FILE: drivers/staging/goldfish/goldfish_nand.c:51:
+   if (cps == NULL)

CHECK: Comparison to NULL could be written "!name"
#333: FILE: drivers/staging/goldfish/goldfish_nand.c:333:
+   if (name == NULL)

CHECK: Comparison to NULL could be written "!r"
#382: FILE: drivers/staging/goldfish/goldfish_nand.c:382:
+   if (r == NULL)

CHECK: Comparison to NULL could be written "!base"
#386: FILE: drivers/staging/goldfish/goldfish_nand.c:386:
+   if (base == NULL)

CHECK: Comparison to NULL could be written "!nand"
#402: FILE: drivers/staging/goldfish/goldfish_nand.c:402:
+   if (nand == NULL)

total: 0 errors, 0 warnings, 5 checks, 442 lines checked

drivers/staging/goldfish/goldfish_nand.c has style problems, please review.

I have also found another commit having the same purpose: 7f376cd6dc1c9bfd14514c70765e6900a961c4b8

-- 
Cheers,
Loïc
