Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3ENO2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:28:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab3ENO2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:28:09 -0400
Date: Tue, 14 May 2013 16:24:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
Message-ID: <20130514142442.GA19392@redhat.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com> <1368494338-7069-18-git-send-email-koverstreet@google.com> <20130514134859.GA17587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514134859.GA17587@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Oleg Nesterov wrote:
>
> I must admit, I do not understand what this code actually does ;)
> I didn't try to read it carefully though, but perhaps at least the
> changelog could explain more?

OK, this is clear...

But perhaps the changelog could explain who needs the "fast" version
of, say, find_next_zero_bit + test_and_set_bit ;) Just curious.

Oleg.

