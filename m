Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3F0Wqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:46:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36624 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754073Ab3F0Wqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:46:30 -0400
Message-ID: <1372373188.2060.32.camel@joe-AO722>
Subject: Re: [PATCH v2] mm: module_alloc: check if size is 0
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 27 Jun 2013 15:46:28 -0700
In-Reply-To: <20130627152335.c3a4c9f4c647cf4a2b263479@linux-foundation.org>
References: <1330631119-10059-1-git-send-email-veli-pekka.peltola@bluegiga.com>
	 <1331125768-25454-1-git-send-email-veli-pekka.peltola@bluegiga.com>
	 <20130627093917.GQ7171@linux-mips.org>
	 <20130627152335.c3a4c9f4c647cf4a2b263479@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 15:23 -0700, Andrew Morton wrote:
> On Thu, 27 Jun 2013 11:39:17 +0200 Ralf Baechle <ralf@linux-mips.org> wrote:
[]
> Veli-Pekka's original patch would be neater if we were to add a new
> 
> void *__vmalloc_node_range_zero_size_ok(<args>)
> {
> 	if (size == 0)
> 		return NULL;

I believe you mean
		return ZERO_SIZE_PTR;


