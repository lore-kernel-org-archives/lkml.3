Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3GAIxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:53:08 -0400
Received: from ozlabs.org ([203.10.76.45]:44090 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab3GAIxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:53:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] mm: module_alloc: check if size is 0
In-Reply-To: <1372373188.2060.32.camel@joe-AO722>
References: <1330631119-10059-1-git-send-email-veli-pekka.peltola@bluegiga.com> <1331125768-25454-1-git-send-email-veli-pekka.peltola@bluegiga.com> <20130627093917.GQ7171@linux-mips.org> <20130627152335.c3a4c9f4c647cf4a2b263479@linux-foundation.org> <1372373188.2060.32.camel@joe-AO722>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 01 Jul 2013 12:48:28 +0930
Message-ID: <87sizzrmrf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> On Thu, 2013-06-27 at 15:23 -0700, Andrew Morton wrote:
>> On Thu, 27 Jun 2013 11:39:17 +0200 Ralf Baechle <ralf@linux-mips.org> wrote:
> []
>> Veli-Pekka's original patch would be neater if we were to add a new
>> 
>> void *__vmalloc_node_range_zero_size_ok(<args>)
>> {
>> 	if (size == 0)
>> 		return NULL;
>
> I believe you mean
> 		return ZERO_SIZE_PTR;

Yes, this is the Right Fix.

Thanks,
Rusty.
