Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbaJ2Vhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:37:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:59096 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaJ2Vht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:37:49 -0400
Date: Wed, 29 Oct 2014 22:37:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz
Subject: Re: mmotm 2014-10-29-14-19 uploaded
In-Reply-To: <54515a25.46WrYSce5BExT3V4%akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1410292233340.5308@nanos>
References: <54515a25.46WrYSce5BExT3V4%akpm@linux-foundation.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, akpm@linux-foundation.org wrote:
> This mmotm tree contains the following patches against 3.18-rc2:
> (patches marked "*" will be included in linux-next)
> 
> * kernel-posix-timersc-code-clean-up.patch

Can you please drop this pointless churn? We really can replace all
that stuff with a shell script and let it run over the tree every now
and then.

Especially if that humanoid "checkpatch.pl" replacement requires a
checkpatch.pl fixup itself.

> * kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch

That's beyond silly, really.

Thanks,

	tglx
