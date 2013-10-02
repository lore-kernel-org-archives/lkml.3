Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3JBQWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab3JBQWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:22:31 -0400
Date: Wed, 2 Oct 2013 18:15:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: suravee.suthikulpanit@amd.com
Cc: fweisbec@gmail.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, tgl@domain.invalid,
        linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH V5 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint
	Extensions
Message-ID: <20131002161547.GA15390@redhat.com>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02, suravee.suthikulpanit@amd.com wrote:
>
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>
> Frederic, this is the rebase of the V4 patch onto the linux-3.12.0-rc3 (linux.git),
> and retest.

But the code is the same? If yes,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


To remind, a range on executable breakpoint is problematic, but I do
not blame this series. We need to fix the generic code and kill
HW_BREAKPOINT_X.

And, heh, it would be nice if the hardware could tell us the _exact_
address (from the range) which should be blamed.

Oleg.

