Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaAWJT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:19:27 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:51549 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaAWJTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:19:25 -0500
Date: Thu, 23 Jan 2014 10:19:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: crash-utility@redhat.com, linux-kernel@vger.kernel.org,
        Dave Anderson <anderson@redhat.com>, Andrew Honig <ahonig@google.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86, kaslr: export offset in VMCOREINFO ELF notes
Message-ID: <20140123091921.GB11454@gmail.com>
References: <20140122235615.GA21632@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122235615.GA21632@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> Include kASLR offset in VMCOREINFO ELF notes to assist in debugging.
> 
> Signed-off-by: Eugene Surovegin <surovegin@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

The signoff sequence is weird. If this came from Eugene then the patch 
is missing a From: line. If he reviewed or acked it then it should be 
a Reviewed-by or Acked-by tag.

Thanks,

	Ingo
