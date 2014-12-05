Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaLEVlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:41:16 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36946 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaLEVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:41:14 -0500
Message-ID: <54822674.20907@gmail.com>
Date: Fri, 05 Dec 2014 13:41:08 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Kees Cook <keescook@chromium.org>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Zubair.Kakakhel@imgtec.com, geert+renesas@glider.be,
        david.daney@cavium.com, Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, davidlohr@hp.com,
        "Maciej W. Rozycki" <macro@linux-mips.org>, chenhc@lemote.com,
        Ingo Molnar <mingo@kernel.org>, Richard Weinberger <richard@nod.at>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        James Hogan <james.hogan@imgtec.com>, Tejun Heo <tj@kernel.org>,
        alex@alex-smith.me.uk, Paolo Bonzini <pbonzini@redhat.com>,
        John Crispin <blogic@openwrt.org>,
        Paul Burton <paul.burton@imgtec.com>, qais.yousef@imgtec.com,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>, dengcheng.zhu@imgtec.com,
        manuel.lauss@gmail.com, lars.persson@axis.com
Subject: Re: [PATCH v3 3/3] MIPS: set stack/data protection as non-executable
References: <20141203015537.13886.50830.stgit@linux-yegoshin> <20141203015824.13886.74616.stgit@linux-yegoshin> <5481EB52.6060706@gmail.com> <CAGXu5jJJx0O7GhHghy+sC4fJL2O=RsO+Zgm78r9SNt-aTbhqcw@mail.gmail.com> <54820244.5010304@gmail.com> <alpine.DEB.2.11.1412051343330.5206@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1412051343330.5206@gentwo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 11:44 AM, Christoph Lameter wrote:
> On Fri, 5 Dec 2014, David Daney wrote:
>
>> The problem is not with "modern" executables that are properly annotated with
>> PT_GNU_STACK.
>>
>> My objection is to the intentional breaking of old executables that have no
>> PT_GNU_STACK annotation, but require an executable stack.  Since we usually
>> try not to break userspace, we cannot merge a patch like this one.
>
> How old are these and how many are still around?

As far as I can determine, no official GCC release defaults to 
generating PT_GNU_STACK for MIPS, I could be mistaken though.  So to 
answer your questions:  Very young, and all of them.


> Can the annotation be added with a tool?

I don't know, although I seem to recall that such a tool existed, and I 
may have even used it in the past.  But, my google fu is not 
sufficiently advanced to find it now, if it exists.

David Daney

