Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab3DEGrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:47:00 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:39095 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3DEGq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:46:59 -0400
Date: Fri, 5 Apr 2013 08:46:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de, eranian@google.com,
        torvalds@linux-foundation.org
Subject: Re: Basic perf PMU support for Haswell v10
Message-ID: <20130405064654.GA25936@gmail.com>
References: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> This is based on v7 of the full Haswell PMU support,

This series looks mostly good - I've got two requests:

 - please rename intx -> in_tx, INTX -> IN_TX, as 'intx' is confusing

 - please port to the latest tip:master (or perf/core), as the underlying
   code changed meanwhile, creating conflicts.

Thanks,

	Ingo
