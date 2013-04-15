Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3DOKgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:36:44 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:52690 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3DOKgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:36:43 -0400
Date: Mon, 15 Apr 2013 12:36:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de, eranian@google.com,
        torvalds@linux-foundation.org
Subject: Re: Basic perf PMU support for Haswell v10
Message-ID: <20130415103639.GA25366@gmail.com>
References: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
 <20130405064654.GA25936@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405064654.GA25936@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > This is based on v7 of the full Haswell PMU support,
> 
> This series looks mostly good - I've got two requests:
> 
>  - please rename intx -> in_tx, INTX -> IN_TX, as 'intx' is confusing
> 
>  - please port to the latest tip:master (or perf/core), as the underlying
>    code changed meanwhile, creating conflicts.

Any update here? If not done this week then you'll possibly miss v3.10 as 
well.

Thanks,

	Ingo
