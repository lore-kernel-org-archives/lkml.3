Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab3IBI4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:56:07 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34581 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758573Ab3IBI4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:56:03 -0400
Message-ID: <5224529D.10009@imgtec.com>
Date: Mon, 2 Sep 2013 09:55:57 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 13/25] mips: Use Kbuild infrastructure to handle asm-generic
 headers
References: <20121013022632.024527228@goodmis.org> <20121013022954.289710602@goodmis.org>
In-Reply-To: <20121013022954.289710602@goodmis.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_09_02_09_55_59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/10/12 03:26, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Use Kbuild infrastructure to handle the asm-generic headers
> and remove the wrapper headers that call them.
> 
> This only affects headers that do nothing but include the generic
> equivalent. It does not touch any header that does a little more.

Hi Steven,

Please see "MIPS: use generic-y where possible" already queued in -next.
cad3b624853b6f34f19693b9812df0d473a6fd40
https://patchwork.linux-mips.org/patch/5581/

Also note, as I said in the commit message:
>     We can't do the same for uapi/asm/kvm_para.h because it's presence is
>     explicitly checked in include/uapi/linux/Kbuild to decide whether to add
>     kvm_para.h to header-y.

so I guess that may need fixing first before half of these patches can
be accepted.

Cheers
James

