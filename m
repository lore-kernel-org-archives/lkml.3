Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaJWP2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:28:54 -0400
Received: from relay3.sgi.com ([192.48.152.1]:54609 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753469AbaJWP2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:28:53 -0400
Date: Thu, 23 Oct 2014 10:29:19 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: linux-mm@kvack.org, athorlton@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Bob Liu <lliubbo@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add pgcollapse controls to task_struct
Message-ID: <20141023152919.GB15104@sgi.com>
References: <1414032567-109765-1-git-send-email-athorlton@sgi.com>
 <1414032567-109765-3-git-send-email-athorlton@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414032567-109765-3-git-send-email-athorlton@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:49:25PM -0500, Alex Thorlton wrote:
> This patch just adds the necessary bits to the task_struct so that the scans can
> eventually be controlled on a per-mm basis.  As I mentioned previously, we might
> want to add some more counters here.

Just noticed that this one didn't get properly numbered when I split
them out.  This should be patch 2/4 for the first set that I sent. Sorry
about that!
