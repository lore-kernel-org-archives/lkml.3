Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3KEQBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:01:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab3KEQBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:01:07 -0500
Date: Tue, 5 Nov 2013 17:01:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/13] uprobes: move function declarations out of
	arch
Message-ID: <20131105160150.GA1539@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-2-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381871068-27660-2-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15, David Long wrote:
>
> Move the function declarations from the arch header to the common
> header, since only the function bodies are architecture-specific.
> These changes are from Vincent Rabin's uprobes patch.

Hmm. I didn't look at this patch because I thought it is obviously
fine, but...

>  arch/x86/include/asm/uprobes.h | 7 -------
>  include/linux/uprobes.h        | 8 ++++++++
>  2 files changed, 8 insertions(+), 7 deletions(-)

it should also update arch/powerpc/include/asm/uprobes.h ?

And 12/13 should not touch arch/powerpc/ or include/linux/uprobes.h.

Oleg.

