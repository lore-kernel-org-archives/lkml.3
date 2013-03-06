Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3CFKap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:30:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3CFKao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:30:44 -0500
MIME-Version: 1.0
In-Reply-To: <20130306102057.GB6587@gmail.com>
References: <CACVXFVNzN721wGm96SroK6cm4E08gs+tJtELsHvxVTCXZtX95g@mail.gmail.com>
	<20130306102057.GB6587@gmail.com>
Date: Wed, 6 Mar 2013 18:30:41 +0800
Message-ID: <CACVXFVMN8=6aLf2NGaLCiLjH+yy7wSmWyRG0w09--0au1vGnLg@mail.gmail.com>
Subject: Re: lockdep: access percpu variable too early
From: Ming Lei <ming.lei@canonical.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 6:20 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> What's the practical effect of it? Do we copy the value from the boot CPU and thus
> the secondary CPUs start with slightly increased stats?

Yes, it is the major effect.

Also the arch dependent __my_cpu_offset might be initialized a bit late.

Thanks,
--
Ming Lei
