Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaDNPtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:49:06 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60398 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753693AbaDNPtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:49:04 -0400
Date: Mon, 14 Apr 2014 10:49:11 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
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
        linux-man@vger.kernel.org
Subject: Re: Documenting prctl() PR_SET_THP_DISABLE and PR_GET_THP_DISABLE
Message-ID: <20140414154911.GH3308@sgi.com>
References: <CAHO5Pa0VCzR7oqNXkwELuAsNQnnvF8Xoo=CuCaM64-GzjDuoFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa0VCzR7oqNXkwELuAsNQnnvF8Xoo=CuCaM64-GzjDuoFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 12:15:01PM +0200, Michael Kerrisk wrote:
> Alex,
> 
> Your commit a0715cc22601e8830ace98366c0c2bd8da52af52 added the prctl()
> PR_SET_THP_DISABLE and PR_GET_THP_DISABLE flags.
> 
> The text below attempts to document these flags for the prctl(3).
> Could you (and anyone else who is willing) please review the text
> below (one or two p[ieces of which are drawn from your commit message)
> to verify that it accurately reflects reality and your intent, and
> that I have not missed any significant details.

Looks fine to me!

- Alex
