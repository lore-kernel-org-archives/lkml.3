Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3C1Nbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:31:44 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:39508 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3C1Nbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130328125439.GB1384@redhat.com>
References: <20130328125439.GB1384@redhat.com>
Date: Thu, 28 Mar 2013 14:31:41 +0100
Message-ID: <CAFTL4hwj0R+VvSPqd_58Y6RnabfXpN1aSKJPGNUYyAh=T-UqHA@mail.gmail.com>
Subject: Re: [PATCH 3.9] cputime: Fix accounting on multi-threaded processes
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/28 Stanislaw Gruszka <sgruszka@redhat.com>:
> Recent commit 6fac4829 "cputime: Use accessors to read task cputime
> stats" introduced a bug, that make we account many times cputime of
> the first thread, instead of cputimes of all threads.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>


Nice catch!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
