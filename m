Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3AXLj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:39:26 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51411 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3AXLjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:39:21 -0500
Date: Thu, 24 Jan 2013 12:39:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org
Subject: Re: perf PMU support for Haswell v7
Message-ID: <20130124113917.GD32259@gmail.com>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> [Updated version for the latest master tree and fixes.  See 
> end for details. All feedback addressed. Ready for merging.]

Could we try a minimal, obvious hardware-enablement series 
first, with all the optional features left out in the first 
step? Your patches look mostly shaped in that way already, so 
this would be mostly a resend of just the basic bits.

( I also finally got access to real Haswell hardware so I'll be
  able to try these out and verify them. The patches are way too
  large to be applied blindly. )

Thanks,

	Ingo
