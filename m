Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaBYXEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:04:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbaBYXEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:04:01 -0500
Message-ID: <530D2141.50707@redhat.com>
Date: Tue, 25 Feb 2014 18:03:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org
CC: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH 3/3] exec: kill the unnecessary mm->def_flags setting
 in load_elf_binary()
References: <cover.1392009759.rs.git.athorlton@sgi.com> <ad2c5e30c22c6398acb62641c054588f105cb4f4.1392009760.git.athorlton@sgi.com>
In-Reply-To: <ad2c5e30c22c6398acb62641c054588f105cb4f4.1392009760.git.athorlton@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:54 PM, Alex Thorlton wrote:
> load_elf_binary() sets current->mm->def_flags = def_flags and
> def_flags is always zero. Not only this looks strange, this is
> unnecessary because mm_init() has already set ->def_flags = 0. 
> 
> Signed-off-by: Alex Thorlton <athorlton@sgi.com>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
