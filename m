Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBYXDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:03:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaBYXDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:03:47 -0500
Message-ID: <530D212E.3020307@redhat.com>
Date: Tue, 25 Feb 2014 18:03:10 -0500
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
Subject: Re: [PATCH 2/3] mm, thp: Add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE
References: <cover.1392009759.rs.git.athorlton@sgi.com> <890608e8ec2968cf6b115411a62f76503ee10331.1392009760.git.athorlton@sgi.com>
In-Reply-To: <890608e8ec2968cf6b115411a62f76503ee10331.1392009760.git.athorlton@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:54 PM, Alex Thorlton wrote:
> This patch adds a VM_INIT_DEF_MASK, to allow us to set the default flags
> for VMs.  It also adds a prctl control which alllows us to set the THP
> disable bit in mm->def_flags so that VMs will pick up the setting as
> they are created.
> 
> Signed-off-by: Alex Thorlton <athorlton@sgi.com>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
