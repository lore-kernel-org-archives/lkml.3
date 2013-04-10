Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936027Ab3DJNdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:33:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41253 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759707Ab3DJNdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:33:49 -0400
Date: Wed, 10 Apr 2013 15:33:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: pageattr: convert noop to functional fix
Message-ID: <20130410133346.GD6857@pd.tnic>
References: <1365600505-19314-1-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365600505-19314-1-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 03:28:25PM +0200, Andrea Arcangeli wrote:
> Commit a8aed3e0752b4beb2e37cbed6df69faae88268da introduced some valid
> fix but one location that didn't trigger the bug that lead to finding
> those (small) problems, wasn't updated using the right variable.
> 
> The wrong variable was also initialized for no good reason, that may
> have been the source of the confusion. Remove the noop initialization
> accordingly.
> 
> Commit a8aed3e0752b4beb2e37cbed6df69faae88268da also erroneously
> removed one canon_pgprot pass meant to clear pmd bitflags not
> supported in hardware by older CPUs, that automatically gets corrected
> by this patch too by applying it to the right variable in the new
> location.
> 
> Reported-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
