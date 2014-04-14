Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaDNVIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:08:48 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57216 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaDNVIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:08:38 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140414154911.GH3308@sgi.com>
References: <CAHO5Pa0VCzR7oqNXkwELuAsNQnnvF8Xoo=CuCaM64-GzjDuoFA@mail.gmail.com>
 <20140414154911.GH3308@sgi.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 14 Apr 2014 23:08:16 +0200
Message-ID: <CAKgNAkicfxhdsa_fa6MCOR-UtbjzYaTv2gRzWq2qKHCuYHc3KA@mail.gmail.com>
Subject: Re: Documenting prctl() PR_SET_THP_DISABLE and PR_GET_THP_DISABLE
To: Alex Thorlton <athorlton@sgi.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 5:49 PM, Alex Thorlton <athorlton@sgi.com> wrote:
> On Mon, Apr 14, 2014 at 12:15:01PM +0200, Michael Kerrisk wrote:
>> Alex,
>>
>> Your commit a0715cc22601e8830ace98366c0c2bd8da52af52 added the prctl()
>> PR_SET_THP_DISABLE and PR_GET_THP_DISABLE flags.
>>
>> The text below attempts to document these flags for the prctl(3).
>> Could you (and anyone else who is willing) please review the text
>> below (one or two p[ieces of which are drawn from your commit message)
>> to verify that it accurately reflects reality and your intent, and
>> that I have not missed any significant details.
>
> Looks fine to me!

Thanks, Alex.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
