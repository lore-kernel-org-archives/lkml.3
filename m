Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3JUO7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:59:47 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60751 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3JUO7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:59:46 -0400
Date: Mon, 21 Oct 2013 16:59:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu: remove this_cpu_xor() implementation
Message-ID: <20131021145941.GA7593@gmail.com>
References: <1382354737-59872-1-git-send-email-heiko.carstens@de.ibm.com>
 <1382354737-59872-2-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382354737-59872-2-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> There is not a single user in the whole kernel.
> Besides that this_cpu_xor() is broken anyway since it gets
> translated to this_cpu_or() (see __pcpu_size_call() line).
> 
> So instead of fixing an unused definition just remove it.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
