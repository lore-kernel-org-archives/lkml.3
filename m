Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaKLFlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:41:55 -0500
Received: from ozlabs.org ([103.22.144.67]:54841 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaKLFly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:41:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org
Cc: geert@linux-m68k.org, peterz@infradead.org, hpa@zytor.com, oleg@redhat.com,
        kirill.shutemov@linux.intel.com, prarit@redhat.com,
        michael.opdenacker@free-electrons.com, fabf@skynet.be,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] Params: Fix parse_args() return code checking
In-Reply-To: <1415740441-1042-1-git-send-email-richard@nod.at>
References: <1415740441-1042-1-git-send-email-richard@nod.at>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 12 Nov 2014 16:04:16 +1030
Message-ID: <87sihpm17r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:
> parse_args() returns beside of NULL also ERR_PTR().

Thanks, already queued in my fixes branch.

Cheers,
Rusty.
