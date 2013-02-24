Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab3BXWKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:10:44 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:47456 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064Ab3BXWKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:10:43 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201302242210.r1OMADAd021416@como.maths.usyd.edu.au>
Date: Mon, 25 Feb 2013 09:10:13 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201302242210.r1OMADAd021416@como.maths.usyd.edu.au>
To: dave@linux.vnet.ibm.com, simon.jeons@gmail.com
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <51209E9C.3020507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Simon,

> So if he config sparse memory, the issue can be solved I think.

In my config file I have:

CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_SPARSE_IRQ=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_SPARSE_RCU_POINTER is not set

Is that sufficient for sparse memory, or should I try something else?
Or maybe, you meant that some kernel source patches might be possible
in the sparse memory code?

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
