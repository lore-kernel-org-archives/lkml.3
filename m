Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaKLJer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:34:47 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaKLJep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:34:45 -0500
Message-ID: <546329AF.1070109@nod.at>
Date: Wed, 12 Nov 2014 10:34:39 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org
CC: geert@linux-m68k.org, peterz@infradead.org, hpa@zytor.com, oleg@redhat.com,
        kirill.shutemov@linux.intel.com, prarit@redhat.com,
        michael.opdenacker@free-electrons.com, fabf@skynet.be,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Params: Fix parse_args() return code checking
References: <1415740441-1042-1-git-send-email-richard@nod.at> <87sihpm17r.fsf@rustcorp.com.au>
In-Reply-To: <87sihpm17r.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.11.2014 um 06:34 schrieb Rusty Russell:
> Richard Weinberger <richard@nod.at> writes:
>> parse_args() returns beside of NULL also ERR_PTR().
> 
> Thanks, already queued in my fixes branch.

I *love* double fixes. ;)

Thanks,
//richard
